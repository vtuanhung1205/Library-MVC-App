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
INSERT INTO "TheLoais" ("TenTheLoai") VALUES 
('Công Nghệ Thông Tin'),      -- 1
('Kinh Tế & Quản Trị'),       -- 2
('Văn Học & Tiểu Thuyết'),    -- 3
('Kỹ Năng Sống'),             -- 4
('Khoa Học Cơ Bản'),          -- 5
('Chính Trị & Pháp Luật'),    -- 6
('Ngoại Ngữ'),                -- 7
('Truyện Tranh'),             -- 8
('Kiến Trúc & Xây Dựng'),     -- 9
('Y Học');                    -- 10

-- Người Dùng
INSERT INTO NguoiDungs (HoTen, Email, MatKhau, VaiTro) VALUES
(N'Quản Trị Viên', 'admin@gmail.com', '123456', 'Admin'),
(N'Sinh Viên A', 'user@gmail.com', '123456', 'User');

-- ============================================================
-- SÁCH THAM KHẢO (BOOKS) - ẢNH BÌA THẬT
-- ============================================================

-- CNTT (ID 1)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
('Clean Code', 'Robert C. Martin', 850000, 'https://m.media-amazon.com/images/I/41xShlnTZTL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0132350884', '005.1 MAR', 'Sách', 1),
('The Pragmatic Programmer', 'David Thomas', 920000, 'https://m.media-amazon.com/images/I/51IA4hT6jrL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0201616224', '005.1 THO', 'Sách', 1),
('Design Patterns', 'Erich Gamma', 890000, 'https://m.media-amazon.com/images/I/51szD9HC9pL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0201633610', '005.1 GAM', 'Sách', 1),
('Introduction to Algorithms', 'Thomas H. Cormen', 1200000, 'https://m.media-amazon.com/images/I/41SNoh5ZhOL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0262033848', '005.1 COR', 'Sách', 1),
('Head First Java', 'Kathy Sierra', 750000, 'https://m.media-amazon.com/images/I/81wAshyxQyL._UF1000,1000_QL80_.jpg', 1, '978-0596009205', '005.133 SIE', 'Sách', 1),
('Code Complete 2', 'Steve McConnell', 950000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ9ekd9M4F56LNOq5Sy2Q20iiQXlZp-JB43A&s', 1, '978-0735619678', '005.1 MCC', 'Sách', 1),
('Refactoring', 'Martin Fowler', 880000, 'https://martinfowler.com/books/refact2.jpg', 1, '978-0201485677', '005.1 FOW', 'Sách', 1),
('The Mythical Man-Month', 'Frederick Brooks', 600000, 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1348430512i/13629.jpg', 1, '978-0201835953', '005.1 BRO', 'Sách', 1),
('You Dont Know JS', 'Kyle Simpson', 450000, 'https://m.media-amazon.com/images/I/817kywRJjVL._AC_UF1000,1000_QL80_.jpg', 1, '978-1491904244', '005.133 SIM', 'Sách', 1),
('Python Crash Course', 'Eric Matthes', 550000, 'https://m.media-amazon.com/images/I/71uiG3qqKaL._AC_UF1000,1000_QL80_.jpg', 1, '978-1593276034', '005.133 MAT', 'Sách', 1);

-- Kinh Tế (ID 2)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
('Rich Dad Poor Dad', 'Robert T. Kiyosaki', 150000, 'https://m.media-amazon.com/images/I/81bsw6fnUiL._SY466_.jpg', 2, '978-1612680194', '332.024 KIY', 'Sách', 1),
('Thinking, Fast and Slow', 'Daniel Kahneman', 250000, 'https://m.media-amazon.com/images/I/61fdrEuPJwL._SY466_.jpg', 2, '978-0374533557', '153.4 KAH', 'Sách', 1),
('Zero to One', 'Peter Thiel', 180000, 'https://m.media-amazon.com/images/I/71uAI28kJuL._SY466_.jpg', 2, '978-0804139298', '658.11 THI', 'Sách', 1),
('The Lean Startup', 'Eric Ries', 190000, 'https://m.media-amazon.com/images/I/81-QB7nDh4L._SY466_.jpg', 2, '978-0307887894', '658.11 RIE', 'Sách', 1),
('Principles', 'Ray Dalio', 300000, 'https://themanreadthebook.com/images/books/1704548487-cover.jpg.jpg', 2, '978-1501124020', '658.4 DAL', 'Sách', 1),
('Shoe Dog', 'Phil Knight', 220000, 'https://bizweb.dktcdn.net/100/326/228/products/shoedogphilknight-fa6d2bc8-30db-491b-9215-c92588ad9285.png?v=1540289795443', 2, '978-1501135910', '338.7 KNI', 'Sách', 1),
('The Intelligent Investor', 'Benjamin Graham', 280000, 'https://m.media-amazon.com/images/I/91+t0Di07FL._SY466_.jpg', 2, '978-0060555665', '332.6 GRA', 'Sách', 1),
('Marketing 4.0', 'Philip Kotler', 160000, 'https://m.media-amazon.com/images/I/71DccJGxsKL._AC_UF1000,1000_QL80_.jpg', 2, '978-1119341208', '658.8 KOT', 'Sách', 1);

-- Văn Học (ID 3)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
('Harry Potter 1', 'J.K. Rowling', 300000, 'https://m.media-amazon.com/images/I/71-++hbbERL._SY466_.jpg', 3, '978-0590353427', '823.914 ROW', 'Sách', 1),
('The Alchemist', 'Paulo Coelho', 79000, 'https://m.media-amazon.com/images/I/71aFt4+OTOL._SY466_.jpg', 3, '978-0061122415', '869.3 COE', 'Sách', 1),
('The Great Gatsby', 'F. Scott Fitzgerald', 120000, 'https://m.media-amazon.com/images/I/71FTb9X6wsL._SY466_.jpg', 3, '978-0743273565', '813.52 FIT', 'Sách', 1),
('To Kill a Mockingbird', 'Harper Lee', 130000, 'https://m.media-amazon.com/images/I/81gepf1eMqL._SY466_.jpg', 3, '978-0061120084', '813.54 LEE', 'Sách', 1),
('1984', 'George Orwell', 110000, 'https://m.media-amazon.com/images/I/71kxa1-0mfL._SY466_.jpg', 3, '978-0451524935', '823.912 ORW', 'Sách', 1),
('Pride and Prejudice', 'Jane Austen', 100000, 'https://m.media-amazon.com/images/I/71Q1tPupKjL._SY466_.jpg', 3, '978-1503290563', '823.7 AUS', 'Sách', 1),
('The Catcher in the Rye', 'J.D. Salinger', 115000, 'https://m.media-amazon.com/images/I/7108sdEUEGL._SY466_.jpg', 3, '978-0316769488', '813.54 SAL', 'Sách', 1),
('The Hobbit', 'J.R.R. Tolkien', 140000, 'https://m.media-amazon.com/images/I/712cDO7d73L._SY466_.jpg', 3, '978-0547928227', '823.912 TOL', 'Sách', 1);

-- Truyện Tranh (ID 8)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
('Naruto Vol 1', 'Masashi Kishimoto', 25000, 'https://m.media-amazon.com/images/I/912xRMMra4L._SY466_.jpg', 8, '978-1569319000', '741.5 KIS', 'Sách', 1),
('One Piece Vol 1', 'Eiichiro Oda', 25000, 'https://m.media-amazon.com/images/I/91NxYvUNf6L._AC_UF1000,1000_QL80_.jpg', 8, '978-1569319017', '741.5 ODA', 'Sách', 1),
('Dragon Ball Vol 1', 'Akira Toriyama', 25000, 'https://m.media-amazon.com/images/I/81-1jqVHePL._AC_UF1000,1000_QL80_.jpg', 8, '978-1569319208', '741.5 TOR', 'Sách', 1),
('Attack on Titan 1', 'Hajime Isayama', 30000, 'https://m.media-amazon.com/images/I/81qPzeEO5IL._AC_UF1000,1000_QL80_.jpg', 8, '978-1612620244', '741.5 ISA', 'Sách', 1),
('Death Note Vol 1', 'Tsugumi Ohba', 30000, 'https://prodimage.images-bn.com/pimages/9781421501680_p0_v4_s1200x630.jpg', 8, '978-1421501680', '741.5 OHB', 'Sách', 1),
('Fullmetal Alchemist 1', 'Hiromu Arakawa', 30000, 'https://m.media-amazon.com/images/I/61yvu+BbxvL._AC_UF1000,1000_QL80_.jpg', 8, '978-1591169208', '741.5 ARA', 'Sách', 1),
('Demon Slayer 1', 'Koyoharu Gotouge', 30000, 'https://m.media-amazon.com/images/I/811qqEcEywL._AC_UF1000,1000_QL80_.jpg', 8, '978-1974700523', '741.5 GOT', 'Sách', 1),
('My Hero Academia 1', 'Kohei Horikoshi', 30000, 'https://m.media-amazon.com/images/I/81AjnD8nvHL._AC_UF1000,1000_QL80_.jpg', 8, '978-1421582696', '741.5 HOR', 'Sách', 1);

-- ============================================================
-- GIÁO TRÌNH (TEXTBOOKS) - ẢNH BÌA HỌC THUẬT
-- ============================================================

-- Giáo trình Đại Cương & Chính Trị (ID 6)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Giáo trình Triết học Mác - Lênin', 'Bộ Giáo Dục', 45000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfRH4wzcFFx1znMlUu9vE3RLui37MDkVnp7w&s', 6, 'GT-001', '335.4 MAC', 'Giáo trình', 1),
(N'Giáo trình Kinh tế Chính trị', 'Bộ Giáo Dục', 42000, 'https://www.nxbctqg.org.vn/img_data/images/036272640018_b1.jpg', 6, 'GT-002', '330 MAC', 'Giáo trình', 1),
(N'Giáo trình Chủ nghĩa Xã hội Khoa học', 'Bộ Giáo Dục', 38000, 'https://www.nxbctqg.org.vn/img_data/images/326523824123_b1.jpg', 6, 'GT-003', '335 CNX', 'Giáo trình', 1),
(N'Giáo trình Tư tưởng Hồ Chí Minh', 'Bộ Giáo Dục', 35000, 'https://www.nxbctqg.org.vn/img_data/images/238626889476_ttkc.jpg', 6, 'GT-004', '335.43 HCM', 'Giáo trình', 1),
(N'Giáo trình Pháp luật Đại cương', 'ĐH Luật', 55000, 'https://www.nxbctqg.org.vn/img_data/images/328595209318_gia%CC%81o-tri%CC%80nh-pha%CC%81p-lua%CC%A3t-da%CC%A3i-cuong.jpg', 6, 'GT-006', '340 PLD', 'Giáo trình', 1);

-- Giáo trình Toán & Khoa học (ID 5)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Giáo trình Toán Cao Cấp A1', 'Nguyễn Đình Trí', 50000, 'https://thuvienvatly.com/home/images/download_thumb/10WP2VIwyczvgkdtF9NAU7pQDOXfKT7qF.jpg', 5, 'GT-007', '510 TRI', 'Giáo trình', 1),
(N'Giáo trình Đại số Tuyến tính', 'ĐH Bách Khoa', 48000, 'https://images.nxbbachkhoa.vn/Picture/2023/8/30/image-20230830145709651.jpg', 5, 'GT-009', '512 DST', 'Giáo trình', 1),
(N'Giáo trình Xác suất Thống kê', 'ĐH Kinh Tế', 55000, 'https://images.nxbbachkhoa.vn/Picture/2022/8/12/image-202208121134579.jpg', 5, 'GT-010', '519 XST', 'Giáo trình', 1),
(N'Giáo trình Vật lý Đại cương 1', 'Lương Duyên Bình', 60000, 'https://tailieuvnu.com/wp-content/uploads/2020/11/30/Giao-trinh-Vat-ly-dai-cuong-tap-1-Luong-Duyen-Binh.png', 5, 'GT-011', '530 BIN', 'Giáo trình', 1),
(N'Giáo trình Hóa học Đại cương', 'Lâm Ngọc Thiềm', 58000, 'https://i.pinimg.com/474x/11/15/22/111522caec8e39207074413e3c0de942.jpg', 5, 'GT-012', '540 THI', 'Giáo trình', 1);

-- Giáo trình CNTT (ID 1)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Giáo trình Nhập môn Lập trình C/C++', 'ĐH KHTN', 65000, 'https://images.vnuhcmpress.edu.vn/Picture/2025/11/10/image-20251110090133270.jpg', 1, 'GT-013', '005.13 KHT', 'Giáo trình', 1),
(N'Giáo trình Cấu trúc dữ liệu & Giải thuật', 'Đỗ Xuân Lôi', 70000, 'https://salt.tikicdn.com/cache/w1200/ts/product/18/36/52/329126ad0de0101a85dce7460df2aec7.jpg', 1, 'GT-014', '005.73 LOI', 'Giáo trình', 1),
(N'Giáo trình Cơ sở dữ liệu', 'ĐH Bách Khoa', 68000, 'https://images.nxbbachkhoa.vn/Picture/2024/5/8/image-20240508161021118.jpg', 1, 'GT-015', '005.74 CSD', 'Giáo trình', 1),
(N'Giáo trình Mạng máy tính', 'Nguyễn Thúc Hải', 75000, 'https://images.nxbxaydung.com.vn/Picture/2025/3/13/image-20250313113450299.png', 1, 'GT-016', '004.6 HAI', 'Giáo trình', 1),
(N'Giáo trình Hệ điều hành', 'ĐH Công Nghệ', 72000, 'https://vietbooks.info/attachments/upload_2023-7-21_15-35-13-png.24762/', 1, 'GT-017', '005.43 HDH', 'Giáo trình', 1);

-- Giáo trình Ngoại Ngữ (ID 7)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Giáo trình Tiếng Anh B1', 'Oxford', 120000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0PM5JCfcYQbNzaLufJ6BgMq9_rdh-CqkKQQ&s', 7, 'GT-025', '428 OXF', 'Giáo trình', 1),
(N'Giáo trình Tiếng Anh B2', 'Cambridge', 130000, 'https://chungchitienganhtinhoc.net/wp-content/uploads/2023/01/sach-Compact-FCE.jpg', 7, 'GT-026', '428 CAM', 'Giáo trình', 1),
(N'Giáo trình Tiếng Nhật Minna no Nihongo 1', '3A Network', 90000, 'https://static.oreka.vn/800-800_f45fdb2e-25af-44f5-91e7-bc71b492205f.jpg', 7, 'GT-027', '495.6 MIN', 'Giáo trình', 1),
(N'Giáo trình Tiếng Trung Hán Ngữ 1', 'ĐH Bắc Kinh', 85000, 'https://static.oreka.vn/800-800_c30e174b-343a-41de-89af-28993a747428.webp', 7, 'GT-028', '495.1 HAN', 'Giáo trình', 1);

-- Giáo trình Y Học (ID 10)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Giáo trình Giải phẫu người', 'Trịnh Văn Minh', 150000, 'https://testyhoc.vn/wp-content/uploads/2024/05/Giai-phau-nguoi-trinh-van-minh-tap-1.jpg', 10, 'GT-030', '611 GPN', 'Giáo trình', 1),
(N'Giáo trình Sinh lý học', 'ĐH Y Hà Nội', 140000, 'https://testyhoc.vn/wp-content/uploads/2023/11/sinh-ly-hoc-y-ha-noi.jpg', 10, 'GT-031', '612 SLH', 'Giáo trình', 1);

-- ============================================================
-- TÀI LIỆU / LUẬN VĂN (DOCUMENTS) - ẢNH BÌA LUẬN VĂN
-- ============================================================

-- Đồ án CNTT (ID 1)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Đồ án: Xây dựng website bán hàng MVC', 'Nguyễn Văn A (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2023-01', 'LV.2023.01', N'Tài liệu', 1),
(N'Đồ án: Ứng dụng AI nhận diện khuôn mặt', 'Trần Thị B (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2023-02', 'LV.2023.02', N'Tài liệu', 1),
(N'Đồ án: Hệ thống quản lý thư viện', 'Lê Văn C (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2022-05', 'LV.2022.05', N'Tài liệu', 1),
(N'Luận văn Thạc sĩ: Big Data trong Y tế', 'ThS. Nguyễn Văn X', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'LV-2021-01', 'LV.2021.01', N'Tài liệu', 1),
(N'Báo cáo thực tập: Công ty FPT Software', 'Sinh viên K15', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'BC-2023-10', 'BC.2023.10', N'Tài liệu', 1);

-- Luận văn Kinh Tế (ID 2)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Luận văn: Phân tích tài chính Vinamilk', 'Lê Thị E (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'LV-2022-08', 'LV.2022.08', N'Tài liệu', 1),
(N'Đồ án: Chiến lược Marketing Shopee', 'Hoàng Văn F (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'DA-2023-05', 'LV.2023.05', N'Tài liệu', 1),
(N'Nghiên cứu: Hành vi tiêu dùng Gen Z', 'Nhóm SV K16', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'NC-2024-02', 'NC.2024.02', N'Tài liệu', 1);

-- Tài liệu Luật (ID 6)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Luận văn: Pháp luật về đất đai 2023', 'Nguyễn Thị G (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 6, 'LV-2022-12', 'LV.2022.12', N'Tài liệu', 1),
(N'Tuyển tập văn bản Luật Dân sự', 'Thư viện Luật', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 6, 'TL-001', 'REF 340', N'Tài liệu', 1);

-- Tài liệu Y Học (ID 10)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Luận văn: Điều trị tiểu đường Type 2', 'BS. Lê Văn H', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 10, 'LV-2021-09', 'LV.2021.09', N'Tài liệu', 1);

-- Tài liệu Xây Dựng (ID 9)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Đồ án: Thiết kế chung cư 20 tầng', 'Phạm Văn I (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 9, 'DA-2022-06', 'LV.2022.06', N'Tài liệu', 1),
(N'Bản vẽ: Cầu dây văng Mỹ Thuận', 'Thư viện Kiến trúc', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 9, 'TL-002', 'REF 720', N'Tài liệu', 1);

-- Tài liệu Ngoại Ngữ (ID 7)
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "CoSan") VALUES
(N'Tuyển tập đề thi IELTS 2023', 'Cambridge', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 7, 'TL-004', 'REF 428', N'Tài liệu', 1),
(N'Đề thi TOEIC có giải chi tiết', 'ETS', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 7, 'TL-005', 'REF 428', N'Tài liệu', 1);

SELECT *FROM Sachs;