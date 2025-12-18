using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyThuVien.Data;
using QuanLyThuVien.Models;
using QuanLyThuVien.Models.ViewModels; // Nhớ using dòng này
using System.Linq;

namespace QuanLyThuVien.Controllers
{
    public class HomeController : Controller
    {
        private readonly ThuVienContext _context;

        public HomeController(ThuVienContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            // 1. Sách Mới: Lấy 12 cuốn mới nhất
            var sachMoi = _context.Sachs.OrderByDescending(s => s.MaSach).Take(12).ToList();

            // 2. Sách Thịnh Hành: Lấy 12 cuốn đầu
            var sachThinhHanh = _context.Sachs.Take(12).ToList();

            // 3. Sách Hay: Lấy 12 cuốn tiếp theo
            var sachHay = _context.Sachs.Skip(12).Take(12).ToList();

            var viewModel = new HomeViewModel
            {
                SachMoi = sachMoi,
                SachThinhHanh = sachThinhHanh,
                SachHay = sachHay
            };

            return View(viewModel);
        }
    }
}