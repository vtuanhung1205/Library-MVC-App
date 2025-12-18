using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyThuVien.Models
{
    public class Sach
    {
        [Key]
        public int MaSach { get; set; }

        [Required]
        [Display(Name = "Nhan đề")]
        public string TenSach { get; set; } = string.Empty;

        [Display(Name = "Tác giả")]
        public string? TacGia { get; set; }

        [Display(Name = "Trị giá")]
        public decimal Gia { get; set; }

        [Display(Name = "ISBN")]
        [StringLength(20)]
        public string? ISBN { get; set; }

        [Display(Name = "Nhà xuất bản")]
        public string? NhaXuatBan { get; set; }

        [Display(Name = "Loại tài liệu")]
        public string LoaiTaiLieu { get; set; } = "Sách";

        [Display(Name = "Năm xuất bản")]
        public int NamXuatBan { get; set; }

        [Display(Name = "Số định danh (Call Number)")]
        public string? SoHieu { get; set; }

        // --- SỬA LỖI TẠI ĐÂY: Đưa biến TomTat lên ngay dưới Attribute của nó ---
        [Display(Name = "Tóm tắt")]
        [DataType(DataType.MultilineText)]
        public string? TomTat { get; set; }
        // -----------------------------------------------------------------------

        [Display(Name = "Tổng số lượng")]
        public int SoLuong { get; set; } = 5;

        [Display(Name = "Đã mượn")]
        public int DaMuon { get; set; } = 0;

        // Thuộc tính tính toán
        [NotMapped]
        public int ConLai => SoLuong - DaMuon;

        [NotMapped]
        public bool CoSan => ConLai > 0;

        public string? AnhBia { get; set; }

        public int MaTheLoai { get; set; }

        [ForeignKey("MaTheLoai")]
        public TheLoai? TheLoai { get; set; }
    }
}