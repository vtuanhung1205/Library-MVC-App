using System.ComponentModel.DataAnnotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace QuanLyThuVien.Models
{
    public class TheLoai
    {
        [Key]
        public int MaTheLoai { get; set; }

        [Required]
        [Display(Name = "Tên Thể Loại")]
        public string TenTheLoai { get; set; } = string.Empty; // Khởi tạo giá trị rỗng để tránh null

        // Khởi tạo list rỗng để tránh null
        public ICollection<Sach> Sachs { get; set; } = new List<Sach>(); 
    }
}