using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyThuVien.Data;
using QuanLyThuVien.Models;
using System.Security.Claims;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using QuanLyThuVien.Models.ViewModels;

namespace QuanLyThuVien.Controllers
{
    // Chỉ cho phép Admin truy cập (Dựa vào Claim Role lúc Login)
    [Authorize(Roles = "Admin")]
    public class AdminController : Controller
    {
        private readonly ThuVienContext _context;

        public AdminController(ThuVienContext context)
        {
            _context = context;
        }

        // 1. Danh sách tất cả phiếu đang mượn
        public IActionResult QuanLyMuonTra()
        {
            var dsMuon = _context.PhieuMuons
                            .Include(p => p.Sach)
                            .Include(p => p.NguoiDung) // Kèm thông tin người mượn
                            .OrderBy(p => p.TrangThai) // Đang mượn lên trước
                            .ThenByDescending(p => p.NgayMuon)
                            .ToList();
            return View(dsMuon);
        }

        // 2. Xác nhận trả sách (Chỉ Admin làm được)
        [HttpPost]
        public IActionResult XacNhanTra(int maPhieu)
        {
            var phieu = _context.PhieuMuons.Include(p => p.Sach).FirstOrDefault(p => p.MaPhieu == maPhieu);

            if (phieu != null && phieu.TrangThai == 0)
            {
                // 1. Tính tiền phạt
                if (DateTime.Now > phieu.HanTra)
                {
                    // Tính số ngày trễ (Làm tròn lên)
                    int soNgayTre = (DateTime.Now - phieu.HanTra).Days;
                    if (soNgayTre > 0)
                    {
                        phieu.TienPhat = soNgayTre * 5000; // 5.000đ mỗi ngày
                    }
                }

                // 2. Cập nhật trạng thái
                phieu.TrangThai = 1;
                if (phieu.Sach != null)
                {
                    phieu.Sach.DaMuon -= 1;
                    if (phieu.Sach.DaMuon < 0) phieu.Sach.DaMuon = 0; // Đề phòng lỗi âm
                }

                _context.SaveChanges();

                // Thông báo kèm tiền phạt (nếu có)
                if (phieu.TienPhat > 0)
                {
                    TempData["Message"] = $"Đã trả sách. KHÁCH PHẢI NỘP PHẠT: {phieu.TienPhat:N0} VNĐ (Trễ {((DateTime.Now - phieu.HanTra).Days)} ngày)";
                }
                else
                {
                    TempData["Message"] = "Đã trả sách thành công (Đúng hạn).";
                }
            }

            return RedirectToAction("QuanLyMuonTra");
        }

        public IActionResult Report()
        {
            // 1. Lấy danh sách tất cả User (trừ Admin)
            var allUsers = _context.NguoiDungs.Where(u => u.VaiTro == "User").ToList();

            // Lấy danh sách phiếu mượn đang kích hoạt (TrangThai = 0)
            var phieuDangMuon = _context.PhieuMuons.Where(p => p.TrangThai == 0).ToList();

            // Lấy danh sách ID người đã từng mượn ít nhất 1 lần
            var userHistoryIds = _context.PhieuMuons.Select(p => p.MaNguoiDung).Distinct().ToList();

            // --- TÍNH TOÁN PHÂN LOẠI USER ---

            // A. User Quá hạn: Có ít nhất 1 phiếu đang mượn mà HanTra < Now
            var userQuaHanIds = phieuDangMuon
                                .Where(p => p.HanTra < DateTime.Now)
                                .Select(p => p.MaNguoiDung)
                                .Distinct()
                                .ToList();

            // B. User Đang mượn (Trong hạn): Có phiếu đang mượn VÀ không có phiếu nào quá hạn
            var userDangMuonIds = phieuDangMuon
                                  .Where(p => p.HanTra >= DateTime.Now)
                                  .Select(p => p.MaNguoiDung)
                                  .Distinct()
                                  .Except(userQuaHanIds) // Loại bỏ những ông đã bị liệt vào nhóm quá hạn
                                  .ToList();

            // C. User Null (Chưa từng mượn gì)
            var userNullCount = allUsers.Count(u => !userHistoryIds.Contains(u.MaNguoiDung));

            // D. User Đã trả (Từng mượn, nhưng hiện tại không giữ cuốn nào)
            // = Tổng user từng mượn - (Đang mượn + Quá hạn)
            var userDaTraCount = userHistoryIds.Count() - (userQuaHanIds.Count + userDangMuonIds.Count);


            // --- TÍNH TOÁN TOP SÁCH HOT ---
            var topSach = _context.PhieuMuons
                            .GroupBy(p => p.MaSach)
                            .Select(g => new { MaSach = g.Key, Count = g.Count() })
                            .OrderByDescending(x => x.Count)
                            .Take(5)
                            .ToList();

            var topSachTen = new List<string>();
            var topSachCount = new List<int>();

            foreach (var item in topSach)
            {
                var ten = _context.Sachs.Find(item.MaSach)?.TenSach ?? "Unknown";
                topSachTen.Add(ten.Length > 20 ? ten.Substring(0, 17) + "..." : ten); // Cắt ngắn tên nếu dài
                topSachCount.Add(item.Count);
            }

            // --- TÍNH TOÁN THỂ LOẠI ---
            var theLoaiStats = _context.Sachs
                                .GroupBy(s => s.MaTheLoai)
                                .Select(g => new { MaTL = g.Key, Count = g.Count() })
                                .ToList();

            var tlTen = new List<string>();
            var tlCount = new List<int>();
            foreach (var item in theLoaiStats)
            {
                tlTen.Add(_context.TheLoais.Find(item.MaTL)?.TenTheLoai ?? "Khác");
                tlCount.Add(item.Count);
            }

            // --- TỔNG HỢP VIEWMODEL ---
            var viewModel = new ReportViewModel
            {
                UserNull = userNullCount,
                UserQuaHan = userQuaHanIds.Count,
                UserDangMuon = userDangMuonIds.Count,
                UserDaTra = userDaTraCount,

                TopSachTen = topSachTen,
                TopSachLuotMuon = topSachCount,

                TheLoaiTen = tlTen,
                TheLoaiSoLuong = tlCount,

                TongSach = _context.Sachs.Sum(s => s.SoLuong),
                TongPhieuMuon = _context.PhieuMuons.Count(),
                TongTienPhat = _context.PhieuMuons.Select(p => p.TienPhat).ToList().Sum()
            };

            return View(viewModel);
        }
    }
}