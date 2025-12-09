using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using QuanLyThuVien.Data;
using QuanLyThuVien.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace QuanLyThuVien.Controllers
{
    [Authorize(Roles = "Admin")]
    public class TheLoaiController : Controller
    {
        private readonly ThuVienContext _context;
        public TheLoaiController(ThuVienContext context) { _context = context; }

        public IActionResult Index() { 
            var danhSachTheLoai = _context.TheLoais
                                          .Include(t => t.Sachs) 
                                          .ToList();
        
            return View(danhSachTheLoai);
        }

        public IActionResult Create() { return View(); }

        [HttpPost]
        public IActionResult Create(TheLoai tl)
        {
            if (ModelState.IsValid)
            {
                _context.TheLoais.Add(tl);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(tl);
        }
    }
}