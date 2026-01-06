using System.Collections.Generic;

namespace QuanLyThuVien.Models.ViewModels
{
    public class ReportViewModel
    {
        // 1. Thống kê Người dùng (Cho biểu đồ tròn)
        public int UserNull { get; set; }      // Chưa từng mượn sách
        public int UserDangMuon { get; set; }  // Đang mượn (trong hạn)
        public int UserQuaHan { get; set; }    // Đang mượn (quá hạn)
        public int UserDaTra { get; set; }     // Đã trả hết, hiện không mượn gì

        // 2. Thống kê Sách (Cho biểu đồ cột)
        public List<string> TopSachTen { get; set; }
        public List<int> TopSachLuotMuon { get; set; }

        // 3. Thống kê Thể loại (Cho biểu đồ Doughnut)
        public List<string> TheLoaiTen { get; set; }
        public List<int> TheLoaiSoLuong { get; set; }

        // 4. Số liệu tổng quan (Cards)
        public int TongSach { get; set; }
        public int TongPhieuMuon { get; set; }
        public decimal TongTienPhat { get; set; }
    }
}