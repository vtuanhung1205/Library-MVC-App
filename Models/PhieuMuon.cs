using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;


namespace QuanLyThuVien.Models
{
    public class PhieuMuon
    {
        [Key]
        public int MaPhieu { get; set; }
        public int MaSach { get; set; }
        public int MaNguoiDung { get; set; }
        public DateTime NgayMuon { get; set; }
        
        public DateTime HanTra { get; set; } 
        public int TrangThai { get; set; }
        public decimal TienPhat { get; set; } = 0; 
        public int SoLanGiaHan { get; set; } = 0;  

        // Navigation Properties
        [ForeignKey("MaSach")]
        public Sach? Sach { get; set; }
        [ForeignKey("MaNguoiDung")]
        public NguoiDung? NguoiDung { get; set; }
    }
}