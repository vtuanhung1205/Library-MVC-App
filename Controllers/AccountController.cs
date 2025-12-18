using Microsoft.AspNetCore.Mvc;
using QuanLyThuVien.Data;
using QuanLyThuVien.Models;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace QuanLyThuVien.Controllers
{
    public class AccountController : Controller
    {
        private readonly ThuVienContext _context;

        public AccountController(ThuVienContext context)
        {
            _context = context;
        }

        // --- ĐĂNG KÝ ---
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Register(NguoiDung user)
        {
            if (ModelState.IsValid)
            {
                var check = _context.NguoiDungs.FirstOrDefault(s => s.Email == user.Email);
                if (check == null)
                {
                    _context.NguoiDungs.Add(user);
                    _context.SaveChanges();
                    return RedirectToAction("Login");
                }
                else
                {
                    ViewBag.Error = "Email này đã tồn tại";
                    return View();
                }
            }
            return View();
        }

        // --- ĐĂNG NHẬP ---
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(string email, string password)
        {
            var user = _context.NguoiDungs.FirstOrDefault(s => s.Email == email && s.MatKhau == password);

            if (user != null)
            {
                // Tạo thông tin phiên làm việc (Claims)
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, user.HoTen),
                    new Claim(ClaimTypes.Email, user.Email),
                    new Claim(ClaimTypes.Role, user.VaiTro ?? "User")
                };

                var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                var authProperties = new AuthenticationProperties();

                // Đăng nhập vào hệ thống
                await HttpContext.SignInAsync(
                    CookieAuthenticationDefaults.AuthenticationScheme,
                    new ClaimsPrincipal(claimsIdentity),
                    authProperties);

                return RedirectToAction("Index", "Sach");
            }
            else
            {
                ViewBag.Error = "Sai thông tin đăng nhập";
                return View();
            }
        }

        [Authorize]
        public IActionResult Profile()
        {
            // 1. Lấy Email người dùng từ Cookie
            var emailUser = User.FindFirst(ClaimTypes.Email)?.Value;

            // 2. Tìm ID người dùng trong Database
            var nguoiDung = _context.NguoiDungs.FirstOrDefault(u => u.Email == emailUser);
            if (nguoiDung == null) return RedirectToAction("Login");

            // 3. Lấy danh sách phiếu mượn của người này
            // Dùng .Include(p => p.Sach) để lấy luôn tên sách và ảnh bìa
            var lichSu = _context.PhieuMuons
                            .Include(p => p.Sach)
                            .Where(p => p.MaNguoiDung == nguoiDung.MaNguoiDung)
                            .OrderByDescending(p => p.NgayMuon) // Mới nhất lên đầu
                            .ToList();

            return View(lichSu);
        }
        [Authorize]
        [HttpPost]
        public IActionResult GiaHan(int maPhieu, DateTime ngayTraMoi)
        {
            var phieu = _context.PhieuMuons.Find(maPhieu);

            if (phieu == null || phieu.TrangThai != 0)
            {
                TempData["Error"] = "Phiếu mượn không hợp lệ.";
                return RedirectToAction("Profile");
            }

            // 1. Kiểm tra: Sách đã quá hạn chưa?
            if (DateTime.Now > phieu.HanTra)
            {
                TempData["Error"] = "Sách đã quá hạn, không thể gia hạn. Vui lòng mang trả và nộp phạt.";
                return RedirectToAction("Profile");
            }

            // 2. Kiểm tra: Đã hết số lần gia hạn chưa? (Ví dụ: Tối đa 2 lần)
            if (phieu.SoLanGiaHan >= 2)
            {
                TempData["Error"] = "Bạn đã hết số lần gia hạn cho cuốn sách này (Tối đa 2 lần).";
                return RedirectToAction("Profile");
            }

            // 3. Kiểm tra: Ngày chọn có hợp lệ không?
            // - Phải lớn hơn hạn cũ
            // - Không được vượt quá 14 ngày so với hạn cũ
            var maxNgayGiaHan = phieu.HanTra.AddDays(14);

            if (ngayTraMoi <= phieu.HanTra)
            {
                TempData["Error"] = "Ngày gia hạn phải sau ngày hạn trả hiện tại.";
            }
            else if (ngayTraMoi > maxNgayGiaHan)
            {
                TempData["Error"] = $"Bạn chỉ được gia hạn tối đa 14 ngày (Đến {maxNgayGiaHan:dd/MM/yyyy}).";
            }
            else
            {
                // Hợp lệ -> Lưu
                phieu.HanTra = ngayTraMoi;
                phieu.SoLanGiaHan += 1;
                _context.SaveChanges();
                TempData["Message"] = $"Gia hạn thành công! Hạn mới là {phieu.HanTra:dd/MM/yyyy}.";
            }

            return RedirectToAction("Profile");
        }
        // --- ĐĂNG XUẤT ---
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login");
        }
    }
}