using System.Collections.Generic;
using QuanLyThuVien.Models;

namespace QuanLyThuVien.Models.ViewModels
{
    public class HomeViewModel
    {
        public IEnumerable<Sach> SachThinhHanh { get; set; }
        public IEnumerable<Sach> SachMoi { get; set; }
        public IEnumerable<Sach> SachHay { get; set; }
    }
}