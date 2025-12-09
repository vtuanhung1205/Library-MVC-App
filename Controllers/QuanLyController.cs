using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering; // Để dùng SelectList
using Microsoft.EntityFrameworkCore;
using QuanLyThuVien.Data;
using QuanLyThuVien.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace QuanLyThuVien.Controllers
{
    [Authorize(Roles = "Admin")] // Chỉ Admin được vào
    public class QuanLySachController : Controller
    {
        private readonly ThuVienContext _context;

        public QuanLySachController(ThuVienContext context)
        {
            _context = context;
        }

        // 1. Danh sách sách
        public IActionResult Index()
        {
            var sachs = _context.Sachs.Include(s => s.TheLoai).ToList();
            return View(sachs);
        }

        // 2. Tạo mới (Giao diện)
        public IActionResult Create()
        {
            // Tạo danh sách chọn Thể loại cho Dropdown
            ViewBag.MaTheLoai = new SelectList(_context.TheLoais, "MaTheLoai", "TenTheLoai");
            return View();
        }

        // 2. Tạo mới (Xử lý logic)
        [HttpPost]
        public IActionResult Create(Sach sach)
        {
            if (ModelState.IsValid)
            {
                _context.Sachs.Add(sach);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaTheLoai = new SelectList(_context.TheLoais, "MaTheLoai", "TenTheLoai", sach.MaTheLoai);
            return View(sach);
        }

        // 3. Sửa (Giao diện)
        public IActionResult Edit(int id)
        {
            var sach = _context.Sachs.Find(id);
            if (sach == null) return NotFound();

            ViewBag.MaTheLoai = new SelectList(_context.TheLoais, "MaTheLoai", "TenTheLoai", sach.MaTheLoai);
            return View(sach);
        }

        // 3. Sửa (Logic)
        [HttpPost]
        public IActionResult Edit(Sach sach)
        {
            if (ModelState.IsValid)
            {
                _context.Update(sach);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaTheLoai = new SelectList(_context.TheLoais, "MaTheLoai", "TenTheLoai", sach.MaTheLoai);
            return View(sach);
        }

        // 4. Xóa
        public IActionResult Delete(int id)
        {
            var sach = _context.Sachs.Find(id);
            if (sach != null)
            {
                _context.Sachs.Remove(sach);
                _context.SaveChanges();
            }
            return RedirectToAction("Index");
        }
    }
}