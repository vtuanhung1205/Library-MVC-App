namespace QuanLyThuVien.Models
{ // <--- Added opening brace
    public class ErrorViewModel
    {
        public string? RequestId { get; set; }

        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
    }
}