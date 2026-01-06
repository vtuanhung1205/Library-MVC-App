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
    [Authorize(Roles = "Admin")]
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
        public IActionResult Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var sach = _context.Sachs.Find(id);
            if (sach == null)
            {
                return NotFound();
            }

            // Tạo danh sách chọn Thể loại, chọn sẵn thể loại hiện tại của sách
            ViewBag.MaTheLoai = new SelectList(_context.TheLoais, "MaTheLoai", "TenTheLoai", sach.MaTheLoai);

            // Tạo danh sách chọn Loại tài liệu
            var loaiTaiLieu = new List<string> { "Sách", "Giáo trình", "Tài liệu" };
            ViewBag.LoaiTaiLieu = new SelectList(loaiTaiLieu, sach.LoaiTaiLieu);

            return View(sach);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, Sach sach)
        {
            if (id != sach.MaSach)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(sach);
                    _context.SaveChanges();
                    TempData["Message"] = "Cập nhật sách thành công!";
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!_context.Sachs.Any(e => e.MaSach == sach.MaSach))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }

            // Nếu lỗi thì load lại dropdown
            ViewBag.MaTheLoai = new SelectList(_context.TheLoais, "MaTheLoai", "TenTheLoai", sach.MaTheLoai);
            var loaiTaiLieu = new List<string> { "Sách", "Giáo trình", "Tài liệu" };
            ViewBag.LoaiTaiLieu = new SelectList(loaiTaiLieu, sach.LoaiTaiLieu);

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