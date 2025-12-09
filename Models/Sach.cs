using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace QuanLyThuVien.Models
{
    public class Sach
    {
        [Key]
        public int MaSach { get; set; }

        [Required]
        [Display(Name = "Nhan đề")] // Thay vì "Tên sách"
        public string TenSach { get; set; } = string.Empty;

        [Display(Name = "Tác giả")]
        public string? TacGia { get; set; }
        
        [Display(Name = "Trị giá")]
        public decimal Gia { get; set; } 

        [Display(Name = "ISBN")]
        [StringLength(20)]
        public string? ISBN { get; set; } // Mã số sách quốc tế

        [Display(Name = "Nhà xuất bản")]
        public string? NhaXuatBan { get; set; }
        
        [Display(Name = "Loại tài liệu")]
        public string LoaiTaiLieu { get; set; } = "Sách";

        [Display(Name = "Năm xuất bản")]
        public int NamXuatBan { get; set; }

        [Display(Name = "Số định danh (Call Number)")]
        public string? SoHieu { get; set; } 

        [Display(Name = "Tóm tắt")]
        [DataType(DataType.MultilineText)]
        public string? TomTat { get; set; }

        public string? AnhBia { get; set; }

        public bool CoSan { get; set; } = true; 

        public int MaTheLoai { get; set; }
        
        [ForeignKey("MaTheLoai")]
        public TheLoai? TheLoai { get; set; }
    }
}