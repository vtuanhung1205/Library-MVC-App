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
                if (phieu.Sach != null) phieu.Sach.CoSan = true;

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
    }
}