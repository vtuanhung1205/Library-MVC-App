USE QuanLyThuVien;
GO

-- 1. Xóa bảng cũ nếu có
IF OBJECT_ID('dbo.PhieuMuons', 'U') IS NOT NULL DROP TABLE dbo.PhieuMuons;
IF OBJECT_ID('dbo.Sachs', 'U') IS NOT NULL DROP TABLE dbo.Sachs;
IF OBJECT_ID('dbo.TheLoais', 'U') IS NOT NULL DROP TABLE dbo.TheLoais;
IF OBJECT_ID('dbo.NguoiDungs', 'U') IS NOT NULL DROP TABLE dbo.NguoiDungs;
GO

-- 2. Tạo bảng Thể Loại
CREATE TABLE [dbo].[TheLoais](
	[MaTheLoai] [int] IDENTITY(1,1) NOT NULL,
	[TenTheLoai] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_TheLoais] PRIMARY KEY CLUSTERED ([MaTheLoai] ASC)
);

-- 3. Tạo bảng Sách
CREATE TABLE [dbo].[Sachs](
	[MaSach] [int] IDENTITY(1,1) NOT NULL,
	[TenSach] [nvarchar](max) NOT NULL,
	[TacGia] [nvarchar](max) NULL,
	[Gia] [decimal](18, 2) NOT NULL DEFAULT 0,
	[AnhBia] [nvarchar](max) NULL,
	[ISBN] [nvarchar](20) NULL,
	[NhaXuatBan] [nvarchar](max) NULL,
	[NamXuatBan] [int] NOT NULL DEFAULT 2000,
	[SoHieu] [nvarchar](50) NULL,
	[TomTat] [nvarchar](max) NULL,
	[CoSan] [bit] NOT NULL DEFAULT 1, -- 1: True, 0: False
	[MaTheLoai] [int] NOT NULL,
	[LoaiTaiLieu] [nvarchar](50) NOT NULL DEFAULT N'Sách',
 CONSTRAINT [PK_Sachs] PRIMARY KEY CLUSTERED ([MaSach] ASC)
);

-- 4. Tạo bảng Người Dùng
CREATE TABLE [dbo].[NguoiDungs](
	[MaNguoiDung] [int] IDENTITY(1,1) NOT NULL,
	[HoTen] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[MatKhau] [nvarchar](max) NOT NULL,
	[VaiTro] [nvarchar](50) NULL DEFAULT 'User',
 CONSTRAINT [PK_NguoiDungs] PRIMARY KEY CLUSTERED ([MaNguoiDung] ASC)
);

-- 5. Tạo bảng Phiếu Mượn
CREATE TABLE [dbo].[PhieuMuons](
	[MaPhieu] [int] IDENTITY(1,1) NOT NULL,
	[MaSach] [int] NOT NULL,
	[MaNguoiDung] [int] NOT NULL,
	[NgayMuon] [datetime2](7) NOT NULL,
	[HanTra] [datetime2](7) NOT NULL,
	[TrangThai] [int] NOT NULL DEFAULT 0,
	[TienPhat] [decimal](18, 2) NOT NULL DEFAULT 0,
	[SoLanGiaHan] [int] NOT NULL DEFAULT 0,
 CONSTRAINT [PK_PhieuMuons] PRIMARY KEY CLUSTERED ([MaPhieu] ASC)
);

-- 6. Tạo Khóa Ngoại (Relationships)
ALTER TABLE [dbo].[Sachs]  WITH CHECK ADD  CONSTRAINT [FK_Sachs_TheLoais_MaTheLoai] FOREIGN KEY([MaTheLoai])
REFERENCES [dbo].[TheLoais] ([MaTheLoai])
ON DELETE CASCADE;

ALTER TABLE [dbo].[PhieuMuons]  WITH CHECK ADD  CONSTRAINT [FK_PhieuMuons_NguoiDungs_MaNguoiDung] FOREIGN KEY([MaNguoiDung])
REFERENCES [dbo].[NguoiDungs] ([MaNguoiDung])
ON DELETE CASCADE;

ALTER TABLE [dbo].[PhieuMuons]  WITH CHECK ADD  CONSTRAINT [FK_PhieuMuons_Sachs_MaSach] FOREIGN KEY([MaSach])
REFERENCES [dbo].[Sachs] ([MaSach])
ON DELETE CASCADE;
GO

-- ==========================================
-- CHÈN DỮ LIỆU MẪU (Đã thêm N'' để hỗ trợ Tiếng Việt)
-- ==========================================

-- Thể Loại
INSERT INTO TheLoais (TenTheLoai) VALUES 
(N'Công Nghệ Thông Tin'), (N'Kinh Tế & Quản Trị'), (N'Văn Học Nước Ngoài'), (N'Kỹ Năng Sống');

-- Người Dùng
INSERT INTO NguoiDungs (HoTen, Email, MatKhau, VaiTro) VALUES
(N'Quản Trị Viên', 'admin@gmail.com', '123456', 'Admin'),
(N'Sinh Viên A', 'user@gmail.com', '123456', 'User');

-- Sách (Mẫu vài cuốn)
INSERT INTO Sachs (TenSach, TacGia, Gia, AnhBia, MaTheLoai, ISBN, SoHieu, LoaiTaiLieu, CoSan) VALUES
(N'Clean Code', N'Robert C. Martin', 850000, 'https://m.media-amazon.com/images/I/41xShlnTZTL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0132350884', '005.1 MAR', N'Sách', 1),
(N'Giáo trình Triết học Mác - Lênin', N'Bộ Giáo Dục', 45000, 'https://m.media-amazon.com/images/I/61+2i+c5z+L._SY466_.jpg', 2, 'GT-001', '335.4 MAC', N'Giáo trình', 1),
(N'Harry Potter 1', N'J.K. Rowling', 300000, 'https://m.media-amazon.com/images/I/71-++hbbERL._SY466_.jpg', 3, '978-0590353427', '823.914 ROW', N'Sách', 1);
GO