using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyThuVien.Data;
using QuanLyThuVien.Models;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace QuanLyThuVien.Controllers
{
    public class SachController : Controller
    {
        private readonly ThuVienContext _context;

        public SachController(ThuVienContext context)
        {
            _context = context;
        }

        public IActionResult Index(string loai)
        {
            var query = _context.Sachs.Include(s => s.TheLoai).AsQueryable();

            if (!string.IsNullOrEmpty(loai))
            {
                
                query = query.Where(s => s.LoaiTaiLieu == loai);
                ViewBag.LoaiHienTai = loai;
            }

            return View(query.ToList());
        }

        public IActionResult TimKiem(string tuKhoa)
        {
            var query = _context.Sachs.Include(s => s.TheLoai).AsQueryable();

            if (!string.IsNullOrEmpty(tuKhoa))
            {
                query = query.Where(s => s.TenSach.Contains(tuKhoa) 
                                    || s.TacGia.Contains(tuKhoa)
                                    || s.ISBN.Contains(tuKhoa)
                                    || s.SoHieu.Contains(tuKhoa));
            }
            
            ViewBag.TuKhoa = tuKhoa; 
            return View("Index", query.ToList());
        }


        public IActionResult Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            
            var sach = _context.Sachs
                .Include(s => s.TheLoai)
                .FirstOrDefault(m => m.MaSach == id);

            if (sach == null)
            {
                return NotFound();
            }

            return View(sach);
        }

        [Authorize]
        [HttpPost] 
        public IActionResult DatMuon(int maSach)
        {
            var sach = _context.Sachs.Find(maSach);
            if (sach == null || sach.CoSan == false) 
            {
                return NotFound("Sách không tồn tại hoặc đã có người mượn.");
            }

            var emailUser = User.FindFirst(ClaimTypes.Email)?.Value;
            var nguoiDung = _context.NguoiDungs.FirstOrDefault(u => u.Email == emailUser);

            if (nguoiDung == null) return RedirectToAction("Login", "Account");

            int soSachDangMuon = _context.PhieuMuons
                            .Count(p => p.MaNguoiDung == nguoiDung.MaNguoiDung && p.TrangThai == 0);

            if (soSachDangMuon >= 3) // Giới hạn 3 cuốn
            {
                TempData["Error"] = "Bạn đã mượn quá giới hạn (3 cuốn). Vui lòng trả sách trước khi mượn thêm.";
                return RedirectToAction("Details", new { id = maSach });
            }

            var phieuMuon = new PhieuMuon
            {
                MaSach = maSach,
                MaNguoiDung = nguoiDung.MaNguoiDung,
                NgayMuon = DateTime.Now,
                 HanTra = DateTime.Now.AddDays(14),
                TrangThai = 0,
                TienPhat = 0,      
                SoLanGiaHan = 0   
            };

            sach.CoSan = false; 

            _context.PhieuMuons.Add(phieuMuon);
            _context.SaveChanges();

            TempData["Message"] = "Đăng ký mượn thành công! Vui lòng đến thư viện nhận sách.";
            return RedirectToAction("Details", new { id = maSach });
        }
    }
}