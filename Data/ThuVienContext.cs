using Microsoft.EntityFrameworkCore;
using QuanLyThuVien.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace QuanLyThuVien.Data
{
    public class ThuVienContext : DbContext
    {
        public ThuVienContext(DbContextOptions<ThuVienContext> options) : base(options) { }

        public DbSet<Sach> Sachs { get; set; }
        public DbSet<TheLoai> TheLoais { get; set; }
        public DbSet<NguoiDung> NguoiDungs { get; set; }
        public DbSet<PhieuMuon> PhieuMuons { get; set; }
    }
}