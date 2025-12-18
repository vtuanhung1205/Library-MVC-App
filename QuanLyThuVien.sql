USE master;
GO

-- 1. Tạo Database nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyThuVien')
BEGIN
    CREATE DATABASE QuanLyThuVien;
END
GO

USE QuanLyThuVien;
GO

-- 2. Xóa bảng cũ (theo thứ tự ràng buộc khóa ngoại)
DROP TABLE IF EXISTS PhieuMuons;
DROP TABLE IF EXISTS Sachs;
DROP TABLE IF EXISTS NguoiDungs;
DROP TABLE IF EXISTS TheLoais;
GO

-- 3. Tạo bảng Thể Loại
CREATE TABLE TheLoais (
    MaTheLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenTheLoai NVARCHAR(255) NOT NULL
);
GO

-- 4. Tạo bảng Sách (Cập nhật đầy đủ cột: SoLuong, DaMuon, LoaiTaiLieu...)
CREATE TABLE Sachs (
    MaSach INT IDENTITY(1,1) PRIMARY KEY,
    TenSach NVARCHAR(MAX) NOT NULL,
    TacGia NVARCHAR(MAX) NULL,
    Gia DECIMAL(18, 2) NOT NULL DEFAULT 0,
    AnhBia NVARCHAR(MAX) NULL,
    ISBN NVARCHAR(20) NULL,
    NhaXuatBan NVARCHAR(MAX) NULL,
    NamXuatBan INT NOT NULL DEFAULT 2000,
    SoHieu NVARCHAR(50) NULL,
    TomTat NVARCHAR(MAX) NULL,
    CoSan BIT NOT NULL DEFAULT 1, -- 1: True, 0: False
    MaTheLoai INT NOT NULL,
    LoaiTaiLieu NVARCHAR(50) NOT NULL DEFAULT N'Sách',
    
    -- CỘT MỚI QUẢN LÝ KHO
    SoLuong INT NOT NULL DEFAULT 5,
    DaMuon INT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Sachs_TheLoais FOREIGN KEY (MaTheLoai) REFERENCES TheLoais(MaTheLoai) ON DELETE CASCADE
);
GO

-- 5. Tạo bảng Người Dùng
CREATE TABLE NguoiDungs (
    MaNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(MAX) NOT NULL,
    Email NVARCHAR(MAX) NOT NULL,
    MatKhau NVARCHAR(MAX) NOT NULL,
    VaiTro NVARCHAR(50) DEFAULT 'User'
);
GO

-- 6. Tạo bảng Phiếu Mượn (Cập nhật cột: TienPhat, SoLanGiaHan)
CREATE TABLE PhieuMuons (
    MaPhieu INT IDENTITY(1,1) PRIMARY KEY,
    MaSach INT NOT NULL,
    MaNguoiDung INT NOT NULL,
    NgayMuon DATETIME2 NOT NULL,
    HanTra DATETIME2 NOT NULL,
    TrangThai INT NOT NULL DEFAULT 0, -- 0: Đang mượn, 1: Đã trả
    
    -- CỘT MỚI NGHIỆP VỤ
    TienPhat DECIMAL(18, 2) NOT NULL DEFAULT 0,
    SoLanGiaHan INT NOT NULL DEFAULT 0,

    CONSTRAINT FK_PhieuMuons_Sachs FOREIGN KEY (MaSach) REFERENCES Sachs(MaSach) ON DELETE CASCADE,
    CONSTRAINT FK_PhieuMuons_NguoiDungs FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDungs(MaNguoiDung) ON DELETE CASCADE
);
GO

-- ==========================================
-- DATA SEEDING (DỮ LIỆU MẪU)
-- Lưu ý: SQL Server cần chữ N trước chuỗi tiếng Việt (N'Chuỗi')
-- ==========================================

-- 1. Thể Loại
INSERT INTO TheLoais (TenTheLoai) VALUES 
(N'Công Nghệ Thông Tin'),      -- 1
(N'Kinh Tế & Quản Trị'),       -- 2
(N'Văn Học & Tiểu Thuyết'),    -- 3
(N'Kỹ Năng Sống'),             -- 4
(N'Khoa Học Cơ Bản'),          -- 5
(N'Chính Trị & Pháp Luật'),    -- 6
(N'Ngoại Ngữ'),                -- 7
(N'Truyện Tranh'),             -- 8
(N'Kiến Trúc & Xây Dựng'),     -- 9
(N'Y Học');                    -- 10

-- 2. Người Dùng
INSERT INTO NguoiDungs (HoTen, Email, MatKhau, VaiTro) VALUES 
(N'Quản Trị Viên', 'admin@gmail.com', '123456', 'Admin'),
(N'Sinh Viên A', 'user@gmail.com', '123456', 'User');

-- ============================================================
-- 1. SÁCH CÔNG NGHỆ THÔNG TIN (ID 1)
-- ============================================================
INSERT INTO Sachs (TenSach, TacGia, Gia, AnhBia, MaTheLoai, ISBN, SoHieu, LoaiTaiLieu, SoLuong, TomTat) VALUES
(N'Clean Code', N'Robert C. Martin', 850000, 'https://m.media-amazon.com/images/I/41xShlnTZTL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0132350884', '005.1 MAR', N'Sách', 10, 
N'Cuốn sách kinh điển về phát triển phần mềm linh hoạt. Tác giả đưa ra các nguyên tắc, mẫu thiết kế và thực hành tốt nhất để viết mã sạch.'),

(N'The Pragmatic Programmer', N'David Thomas', 920000, 'https://m.media-amazon.com/images/I/51IA4hT6jrL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0201616224', '005.1 THO', N'Sách', 8, 
N'Khám phá cốt lõi của quy trình phát triển phần mềm. Sách cung cấp những lời khuyên thực tế về mọi khía cạnh của lập trình.'),

(N'Design Patterns', N'Erich Gamma', 890000, 'https://m.media-amazon.com/images/I/51szD9HC9pL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0201633610', '005.1 GAM', N'Sách', 5, 
N'Cuốn sách nền tảng về các mẫu thiết kế hướng đối tượng. Giới thiệu 23 mẫu thiết kế kinh điển.'),

(N'Introduction to Algorithms', N'Thomas H. Cormen', 1200000, 'https://m.media-amazon.com/images/I/41SNoh5ZhOL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0262033848', '005.1 COR', N'Sách', 3, 
N'Được mệnh danh là Kinh thánh về thuật toán. Sách bao gồm đầy đủ các thuật toán từ cơ bản đến nâng cao.'),

(N'Head First Java', N'Kathy Sierra', 750000, 'https://m.media-amazon.com/images/I/81wAshyxQyL._UF1000,1000_QL80_.jpg', 1, '978-0596009205', '005.133 SIE', N'Sách', 7, 
N'Cách tiếp cận học Java hoàn toàn mới mẻ và trực quan. Sử dụng hình ảnh, câu đố và ví dụ thực tế.'),

(N'Code Complete 2', N'Steve McConnell', 950000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ9ekd9M4F56LNOq5Sy2Q20iiQXlZp-JB43A&s', 1, '978-0735619678', '005.1 MCC', N'Sách', 5, 
N'Cẩm nang toàn diện về xây dựng phần mềm. Sách tổng hợp các kỹ thuật thực tế tốt nhất trong việc thiết kế, viết code.'),

(N'Refactoring', N'Martin Fowler', 880000, 'https://martinfowler.com/books/refact2.jpg', 1, '978-0201485677', '005.1 FOW', N'Sách', 5, 
N'Hướng dẫn chi tiết về kỹ thuật tái cấu trúc mã nguồn. Cách cải thiện thiết kế của code hiện có.'),

(N'The Mythical Man-Month', N'Frederick Brooks', 600000, 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1348430512i/13629.jpg', 1, '978-0201835953', '005.1 BRO', N'Sách', 5, 
N'Tập hợp các bài luận kinh điển về kỹ nghệ phần mềm. Nổi tiếng với định luật Brooks.'),

(N'You Dont Know JS', N'Kyle Simpson', 450000, 'https://m.media-amazon.com/images/I/817kywRJjVL._AC_UF1000,1000_QL80_.jpg', 1, '978-1491904244', '005.133 SIM', N'Sách', 5, 
N'Bộ sách đi sâu vào các cơ chế cốt lõi của JavaScript như Scope, Closures, this, Object Prototypes.'),

(N'Python Crash Course', N'Eric Matthes', 550000, 'https://m.media-amazon.com/images/I/71uiG3qqKaL._AC_UF1000,1000_QL80_.jpg', 1, '978-1593276034', '005.133 MAT', N'Sách', 5, 
N'Sách nhập môn Python bán chạy nhất thế giới. Đi từ các khái niệm cơ bản đến các dự án thực tế.');

-- ============================================================
-- 2. SÁCH KINH TẾ (ID 2)
-- ============================================================
INSERT INTO Sachs (TenSach, TacGia, Gia, AnhBia, MaTheLoai, ISBN, SoHieu, LoaiTaiLieu, TomTat) VALUES
(N'Rich Dad Poor Dad', N'Robert T. Kiyosaki', 150000, 'https://m.media-amazon.com/images/I/81bsw6fnUiL._SY466_.jpg', 2, '978-1612680194', '332.024 KIY', N'Sách', 
N'Cuốn sách tài chính cá nhân số 1 mọi thời đại. Tác giả chia sẻ những bài học về tiền bạc mà người giàu dạy con cái họ.'),

(N'Thinking, Fast and Slow', N'Daniel Kahneman', 250000, 'https://m.media-amazon.com/images/I/61fdrEuPJwL._SY466_.jpg', 2, '978-0374533557', '153.4 KAH', N'Sách', 
N'Khám phá hai hệ thống tư duy điều khiển cách chúng ta suy nghĩ: Hệ thống 1 nhanh, trực quan và cảm tính; Hệ thống 2 chậm.'),

(N'Zero to One', N'Peter Thiel', 180000, 'https://m.media-amazon.com/images/I/71uAI28kJuL._SY466_.jpg', 2, '978-0804139298', '658.11 THI', N'Sách', 
N'Ghi chép về khởi nghiệp và cách xây dựng tương lai. Peter Thiel lập luận rằng sự tiến bộ đến từ việc độc quyền.'),

(N'The Lean Startup', N'Eric Ries', 190000, 'https://m.media-amazon.com/images/I/81-QB7nDh4L._SY466_.jpg', 2, '978-0307887894', '658.11 RIE', N'Sách', 
N'Phương pháp khởi nghiệp tinh gọn giúp các doanh nhân xây dựng công ty hiệu quả hơn bằng cách liên tục kiểm thử.'),

(N'Principles', N'Ray Dalio', 300000, 'https://themanreadthebook.com/images/books/1704548487-cover.jpg.jpg', 2, '978-1501124020', '658.4 DAL', N'Sách', 
N'Ray Dalio chia sẻ những nguyên tắc sống và làm việc độc đáo đã giúp ông xây dựng Bridgewater Associates.'),

(N'Shoe Dog', N'Phil Knight', 220000, 'https://bizweb.dktcdn.net/100/326/228/products/shoedogphilknight-fa6d2bc8-30db-491b-9215-c92588ad9285.png?v=1540289795443', 2, '978-1501135910', '338.7 KNI', N'Sách', 
N'Hồi ký đầy cảm hứng của nhà sáng lập Nike. Câu chuyện chân thực về hành trình khởi nghiệp đầy gian nan.'),

(N'The Intelligent Investor', N'Benjamin Graham', 280000, 'https://m.media-amazon.com/images/I/91+t0Di07FL._SY466_.jpg', 2, '978-0060555665', '332.6 GRA', N'Sách', 
N'Cuốn sách gối đầu giường của Warren Buffett. Giới thiệu triết lý đầu tư giá trị.'),

(N'Marketing 4.0', N'Philip Kotler', 160000, 'https://m.media-amazon.com/images/I/71DccJGxsKL._AC_UF1000,1000_QL80_.jpg', 2, '978-1119341208', '658.8 KOT', N'Sách', 
N'Dịch chuyển từ tiếp thị truyền thống sang kỹ thuật số. Sách hướng dẫn cách doanh nghiệp tương tác với khách hàng.');

-- ============================================================
-- 3. VĂN HỌC (ID 3)
-- ============================================================
INSERT INTO Sachs (TenSach, TacGia, Gia, AnhBia, MaTheLoai, ISBN, SoHieu, LoaiTaiLieu, TomTat) VALUES
(N'Harry Potter 1', N'J.K. Rowling', 300000, 'https://m.media-amazon.com/images/I/71-++hbbERL._SY466_.jpg', 3, '978-0590353427', '823.914 ROW', N'Sách', 
N'Tập đầu tiên trong bộ truyện lừng danh. Harry Potter, một cậu bé mồ côi, phát hiện ra mình là phù thủy.'),

(N'The Alchemist', N'Paulo Coelho', 79000, 'https://m.media-amazon.com/images/I/71aFt4+OTOL._SY466_.jpg', 3, '978-0061122415', '869.3 COE', N'Sách', 
N'Câu chuyện ngụ ngôn về Santiago, một chàng chăn cừu trẻ tuổi đi tìm kho báu.'),

(N'The Great Gatsby', N'F. Scott Fitzgerald', 120000, 'https://m.media-amazon.com/images/I/71FTb9X6wsL._SY466_.jpg', 3, '978-0743273565', '813.52 FIT', N'Sách', 
N'Bức tranh về Giấc mơ Mỹ thời đại Jazz. Qua lời kể của Nick Carraway, câu chuyện về đại gia Gatsby bí ẩn.'),

(N'To Kill a Mockingbird', N'Harper Lee', 130000, 'https://m.media-amazon.com/images/I/81gepf1eMqL._SY466_.jpg', 3, '978-0061120084', '813.54 LEE', N'Sách', 
N'Một tác phẩm kinh điển về nạn phân biệt chủng tộc và sự mất mát của sự ngây thơ ở miền Nam nước Mỹ.'),

(N'1984', N'George Orwell', 110000, 'https://m.media-amazon.com/images/I/71kxa1-0mfL._SY466_.jpg', 3, '978-0451524935', '823.912 ORW', N'Sách', 
N'Tiểu thuyết phản địa đàng mô tả một xã hội toàn trị dưới sự giám sát của Anh Cả.'),

(N'Pride and Prejudice', N'Jane Austen', 100000, 'https://m.media-amazon.com/images/I/71Q1tPupKjL._SY466_.jpg', 3, '978-1503290563', '823.7 AUS', N'Sách', 
N'Câu chuyện tình yêu lãng mạn và hài hước giữa Elizabeth Bennet thông minh và quý ngài Darcy kiêu ngạo.'),

(N'The Catcher in the Rye', N'J.D. Salinger', 115000, 'https://m.media-amazon.com/images/I/7108sdEUEGL._SY466_.jpg', 3, '978-0316769488', '813.54 SAL', N'Sách', 
N'Hành trình của Holden Caulfield, một thiếu niên nổi loạn lang thang ở New York sau khi bị đuổi học.'),

(N'The Hobbit', N'J.R.R. Tolkien', 140000, 'https://m.media-amazon.com/images/I/712cDO7d73L._SY466_.jpg', 3, '978-0547928227', '823.912 TOL', N'Sách', 
N'Câu chuyện về Bilbo Baggins, một người Hobbit thích yên bình, bị cuốn vào cuộc phiêu lưu giành lại kho báu.');

-- ============================================================
-- 4. TRUYỆN TRANH (ID 8)
-- ============================================================
INSERT INTO Sachs (TenSach, TacGia, Gia, AnhBia, MaTheLoai, ISBN, SoHieu, LoaiTaiLieu, TomTat) VALUES
(N'Naruto Vol 1', N'Masashi Kishimoto', 25000, 'https://m.media-amazon.com/images/I/912xRMMra4L._SY466_.jpg', 8, '978-1569319000', '741.5 KIS', N'Sách', 
N'Khởi đầu hành trình của Naruto Uzumaki, một ninja trẻ tuổi hiếu động luôn muốn tìm cách khẳng định mình.'),

(N'One Piece Vol 1', N'Eiichiro Oda', 25000, 'https://m.media-amazon.com/images/I/91d0K2O-xCL._SY466_.jpg', 8, '978-1569319017', '741.5 ODA', N'Sách', 
N'Luffy Mũ Rơm ra khơi để tìm kiếm kho báu huyền thoại One Piece và trở thành Vua Hải Tặc.'),

(N'Dragon Ball Vol 1', N'Akira Toriyama', 25000, 'https://m.media-amazon.com/images/I/81-1jqVHePL._AC_UF1000,1000_QL80_.jpg', 8, '978-1569319208', '741.5 TOR', N'Sách', 
N'Goku, một cậu bé có đuôi khỉ, gặp gỡ Bulma và cùng nhau lên đường tìm kiếm 7 viên ngọc rồng.'),

(N'Attack on Titan 1', N'Hajime Isayama', 30000, 'https://m.media-amazon.com/images/I/81qPzeEO5IL._AC_UF1000,1000_QL80_.jpg', 8, '978-1612620244', '741.5 ISA', N'Sách', 
N'Nhân loại sống trong các bức tường để trốn tránh những người khổng lồ ăn thịt người.'),

(N'Death Note Vol 1', N'Tsugumi Ohba', 30000, 'https://prodimage.images-bn.com/pimages/9781421501680_p0_v4_s1200x630.jpg', 8, '978-1421501680', '741.5 OHB', N'Sách', 
N'Light Yagami nhặt được cuốn sổ tử thần, cho phép giết bất cứ ai bị ghi tên vào đó.'),

(N'Fullmetal Alchemist 1', N'Hiromu Arakawa', 30000, 'https://m.media-amazon.com/images/I/61yvu+BbxvL._AC_UF1000,1000_QL80_.jpg', 8, '978-1591169208', '741.5 ARA', N'Sách', 
N'Hai anh em Edward và Alphonse Elric sử dụng giả kim thuật để hồi sinh mẹ nhưng thất bại thảm hại.'),

(N'Demon Slayer 1', N'Koyoharu Gotouge', 30000, 'https://m.media-amazon.com/images/I/811qqEcEywL._AC_UF1000,1000_QL80_.jpg', 8, '978-1974700523', '741.5 GOT', N'Sách', 
N'Tanjiro trở thành thợ săn quỷ để tìm cách biến em gái Nezuko trở lại thành người sau khi gia đình cậu bị quỷ sát hại.'),

(N'My Hero Academia 1', N'Kohei Horikoshi', 30000, 'https://m.media-amazon.com/images/I/81AjnD8nvHL._AC_UF1000,1000_QL80_.jpg', 8, '978-1421582696', '741.5 HOR', N'Sách', 
N'Trong thế giới mà ai cũng có siêu năng lực, Midoriya Izuku lại sinh ra vô năng. Tuy nhiên, cậu vẫn mơ ước trở thành anh hùng.');

-- ============================================================
-- 5. GIÁO TRÌNH (TEXTBOOKS)
-- ============================================================
INSERT INTO Sachs (TenSach, TacGia, Gia, AnhBia, MaTheLoai, ISBN, SoHieu, LoaiTaiLieu, TomTat) VALUES
(N'Giáo trình Triết học Mác - Lênin', N'Bộ Giáo Dục', 45000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfRH4wzcFFx1znMlUu9vE3RLui37MDkVnp7w&s', 6, 'GT-001', '335.4 MAC', N'Giáo trình', 
N'Tài liệu học tập chính thức dùng cho sinh viên đại học, cao đẳng. Cung cấp hệ thống kiến thức cơ bản về chủ nghĩa duy vật biện chứng.'),

(N'Giáo trình Kinh tế Chính trị', N'Bộ Giáo Dục', 42000, 'https://www.nxbctqg.org.vn/img_data/images/036272640018_b1.jpg', 6, 'GT-002', '330 MAC', N'Giáo trình', 
N'Trình bày các quy luật kinh tế cơ bản của phương thức sản xuất tư bản chủ nghĩa và những vấn đề kinh tế chính trị.'),

(N'Giáo trình Chủ nghĩa Xã hội Khoa học', N'Bộ Giáo Dục', 38000, 'https://www.nxbctqg.org.vn/img_data/images/326523824123_b1.jpg', 6, 'GT-003', '335 CNX', N'Giáo trình', 
N'Nghiên cứu về sứ mệnh lịch sử của giai cấp công nhân và quá trình hình thành, phát triển của hình thái kinh tế - xã hội cộng sản chủ nghĩa.'),

(N'Giáo trình Tư tưởng Hồ Chí Minh', N'Bộ Giáo Dục', 35000, 'https://www.nxbctqg.org.vn/img_data/images/238626889476_ttkc.jpg', 6, 'GT-004', '335.43 HCM', N'Giáo trình', 
N'Hệ thống quan điểm toàn diện và sâu sắc về những vấn đề cơ bản của cách mạng Việt Nam.'),

(N'Giáo trình Pháp luật Đại cương', N'ĐH Luật', 55000, 'https://www.nxbctqg.org.vn/img_data/images/328595209318_gia%CC%81o-tri%CC%80nh-pha%CC%81p-lua%CC%A3t-da%CC%A3i-cuong.jpg', 6, 'GT-006', '340 PLD', N'Giáo trình', 
N'Cung cấp những kiến thức cơ bản nhất về Nhà nước và Pháp luật, là môn học bắt buộc cho sinh viên năm nhất.'),

(N'Giáo trình Toán Cao Cấp A1', N'Nguyễn Đình Trí', 50000, 'https://thuvienvatly.com/home/images/download_thumb/10WP2VIwyczvgkdtF9NAU7pQDOXfKT7qF.jpg', 5, 'GT-007', '510 TRI', N'Giáo trình', 
N'Giáo trình dành cho sinh viên các khối kỹ thuật. Nội dung bao gồm: Giới hạn, Hàm số một biến số, Phép tính vi phân và tích phân.'),

(N'Giáo trình Đại số Tuyến tính', N'ĐH Bách Khoa', 48000, 'https://images.nxbbachkhoa.vn/Picture/2023/8/30/image-20230830145709651.jpg', 5, 'GT-009', '512 DST', N'Giáo trình', 
N'Nghiên cứu về không gian vector, ma trận, định thức và hệ phương trình tuyến tính.'),

(N'Giáo trình Xác suất Thống kê', N'ĐH Kinh Tế', 55000, 'https://images.nxbbachkhoa.vn/Picture/2022/8/12/image-202208121134579.jpg', 5, 'GT-010', '519 XST', N'Giáo trình', 
N'Cung cấp các công cụ toán học để xử lý dữ liệu, phân tích rủi ro và đưa ra dự báo.'),

(N'Giáo trình Vật lý Đại cương 1', N'Lương Duyên Bình', 60000, 'https://tailieuvnu.com/wp-content/uploads/2020/11/30/Giao-trinh-Vat-ly-dai-cuong-tap-1-Luong-Duyen-Binh.png', 5, 'GT-011', '530 BIN', N'Giáo trình', 
N'Nội dung về Cơ học, Nhiệt học và Động lực học chất điểm.'),

(N'Giáo trình Hóa học Đại cương', N'Lâm Ngọc Thiềm', 58000, 'https://i.pinimg.com/474x/11/15/22/111522caec8e39207074413e3c0de942.jpg', 5, 'GT-012', '540 THI', N'Giáo trình', 
N'Kiến thức nền tảng về cấu tạo chất, nhiệt động học hóa học và động hóa học.'),

(N'Giáo trình Nhập môn Lập trình C/C++', N'ĐH KHTN', 65000, 'https://images.vnuhcmpress.edu.vn/Picture/2025/11/10/image-20251110090133270.jpg', 1, 'GT-013', '005.13 KHT', N'Giáo trình', 
N'Tài liệu nhập môn cho sinh viên CNTT. Giới thiệu tư duy lập trình cấu trúc, các kiểu dữ liệu, vòng lặp, hàm.'),

(N'Giáo trình Cấu trúc dữ liệu & Giải thuật', N'Đỗ Xuân Lôi', 70000, 'https://salt.tikicdn.com/cache/w1200/ts/product/18/36/52/329126ad0de0101a85dce7460df2aec7.jpg', 1, 'GT-014', '005.73 LOI', N'Giáo trình', 
N'Môn học cốt lõi của ngành CNTT. Nghiên cứu các cấu trúc lưu trữ dữ liệu như Danh sách liên kết, Cây, Đồ thị.'),

(N'Giáo trình Cơ sở dữ liệu', N'ĐH Bách Khoa', 68000, 'https://images.nxbbachkhoa.vn/Picture/2024/5/8/image-20240508161021118.jpg', 1, 'GT-015', '005.74 CSD', N'Giáo trình', 
N'Giới thiệu về mô hình dữ liệu quan hệ, ngôn ngữ SQL và thiết kế cơ sở dữ liệu chuẩn hóa.'),

(N'Giáo trình Mạng máy tính', N'Nguyễn Thúc Hải', 75000, 'https://images.nxbxaydung.com.vn/Picture/2025/3/13/image-20250313113450299.png', 1, 'GT-016', '004.6 HAI', N'Giáo trình', 
N'Kiến thức về mô hình OSI, TCP/IP, các giao thức mạng và cách thức truyền tải dữ liệu trên Internet.'),

(N'Giáo trình Hệ điều hành', N'ĐH Công Nghệ', 72000, 'https://vietbooks.info/attachments/upload_2023-7-21_15-35-13-png.24762/', 1, 'GT-017', '005.43 HDH', N'Giáo trình', 
N'Nghiên cứu cách quản lý tài nguyên máy tính, lập lịch tiến trình, quản lý bộ nhớ và hệ thống tập tin.'),

(N'Giáo trình Tiếng Anh B1', N'Oxford', 120000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0PM5JCfcYQbNzaLufJ6BgMq9_rdh-CqkKQQ&s', 7, 'GT-025', '428 OXF', N'Giáo trình', 
N'Sách luyện thi và học tập tiếng Anh trình độ B1 theo khung tham chiếu Châu Âu (CEFR).'),

(N'Giáo trình Tiếng Anh B2', N'Cambridge', 130000, 'https://chungchitienganhtinhoc.net/wp-content/uploads/2023/01/sach-Compact-FCE.jpg', 7, 'GT-026', '428 CAM', N'Giáo trình', 
N'Tài liệu nâng cao cho sinh viên chuyên ngữ, tập trung vào kỹ năng viết luận và thuyết trình.'),

(N'Giáo trình Tiếng Nhật Minna no Nihongo 1', N'3A Network', 90000, 'https://static.oreka.vn/800-800_f45fdb2e-25af-44f5-91e7-bc71b492205f.jpg', 7, 'GT-027', '495.6 MIN', N'Giáo trình', 
N'Giáo trình tiếng Nhật sơ cấp phổ biến nhất thế giới, dành cho người mới bắt đầu.'),

(N'Giáo trình Tiếng Trung Hán Ngữ 1', N'ĐH Bắc Kinh', 85000, 'https://static.oreka.vn/800-800_c30e174b-343a-41de-89af-28993a747428.webp', 7, 'GT-028', '495.1 HAN', N'Giáo trình', 
N'Bộ giáo trình chuẩn để học tiếng Trung Quốc, tập trung vào phát âm và chữ Hán cơ bản.'),

(N'Giáo trình Giải phẫu người', N'Trịnh Văn Minh', 150000, 'https://testyhoc.vn/wp-content/uploads/2024/05/Giai-phau-nguoi-trinh-van-minh-tap-1.jpg', 10, 'GT-030', '611 GPN', N'Giáo trình', 
N'Tài liệu kinh điển cho sinh viên Y khoa. Mô tả chi tiết cấu trúc giải phẫu cơ thể người.'),

(N'Giáo trình Sinh lý học', N'ĐH Y Hà Nội', 140000, 'https://testyhoc.vn/wp-content/uploads/2023/11/sinh-ly-hoc-y-ha-noi.jpg', 10, 'GT-031', '612 SLH', N'Giáo trình', 
N'Nghiên cứu chức năng và hoạt động của các cơ quan trong cơ thể người.');

-- ============================================================
-- 6. TÀI LIỆU / LUẬN VĂN (DOCUMENTS)
-- ============================================================
INSERT INTO Sachs (TenSach, TacGia, Gia, AnhBia, MaTheLoai, ISBN, SoHieu, LoaiTaiLieu, TomTat) VALUES
(N'Đồ án: Xây dựng website bán hàng MVC', N'Nguyễn Văn A (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2023-01', 'LV.2023.01', N'Tài liệu', 
N'Đồ án tốt nghiệp kỹ sư CNTT. Đề tài nghiên cứu và xây dựng hệ thống thương mại điện tử sử dụng công nghệ ASP.NET Core MVC.'),

(N'Đồ án: Ứng dụng AI nhận diện khuôn mặt', N'Trần Thị B (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2023-02', 'LV.2023.02', N'Tài liệu', 
N'Nghiên cứu các thuật toán Deep Learning (CNN) để nhận diện khuôn mặt trong hệ thống chấm công.'),

(N'Đồ án: Hệ thống quản lý thư viện', N'Lê Văn C (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2022-05', 'LV.2022.05', N'Tài liệu', 
N'Xây dựng phần mềm quản lý thư viện trường đại học, tích hợp chức năng mượn trả sách tự động.'),

(N'Luận văn Thạc sĩ: Big Data trong Y tế', N'ThS. Nguyễn Văn X', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'LV-2021-01', 'LV.2021.01', N'Tài liệu', 
N'Ứng dụng công nghệ Big Data để phân tích hồ sơ bệnh án điện tử và dự đoán dịch bệnh.'),

(N'Báo cáo thực tập: Công ty FPT Software', N'Sinh viên K15', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'BC-2023-10', 'BC.2023.10', N'Tài liệu', 
N'Báo cáo quá trình thực tập tại vị trí Java Developer tại FPT Software.'),

(N'Luận văn: Phân tích tài chính Vinamilk', N'Lê Thị E (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'LV-2022-08', 'LV.2022.08', N'Tài liệu', 
N'Phân tích các chỉ số tài chính, khả năng thanh khoản và hiệu quả hoạt động của công ty Vinamilk.'),

(N'Đồ án: Chiến lược Marketing Shopee', N'Hoàng Văn F (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'DA-2023-05', 'LV.2023.05', N'Tài liệu', 
N'Phân tích chiến lược Marketing Mix (4P) của Shopee tại thị trường Việt Nam.'),

(N'Nghiên cứu: Hành vi tiêu dùng Gen Z', N'Nhóm SV K16', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'NC-2024-02', 'NC.2024.02', N'Tài liệu', 
N'Khảo sát thói quen mua sắm trực tuyến của thế hệ Z tại Hà Nội.'),

(N'Luận văn: Pháp luật về đất đai 2023', N'Nguyễn Thị G (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 6, 'LV-2022-12', 'LV.2022.12', N'Tài liệu', 
N'Nghiên cứu những điểm mới trong Luật Đất đai sửa đổi năm 2023.'),

(N'Tuyển tập văn bản Luật Dân sự', N'Thư viện Luật', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 6, 'TL-001', 'REF 340', N'Tài liệu', 
N'Tổng hợp các văn bản dưới luật hướng dẫn thi hành Bộ luật Dân sự 2015.'),

(N'Luận văn: Điều trị tiểu đường Type 2', N'BS. Lê Văn H', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 10, 'LV-2021-09', 'LV.2021.09', N'Tài liệu', 
N'Nghiên cứu phác đồ điều trị mới cho bệnh nhân tiểu đường tuýp 2 tại bệnh viện Bạch Mai.'),

(N'Đồ án: Thiết kế chung cư 20 tầng', N'Phạm Văn I (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 9, 'DA-2022-06', 'LV.2022.06', N'Tài liệu', 
N'Bản vẽ thiết kế kiến trúc và kết cấu cho tòa nhà chung cư cao tầng.'),

(N'Bản vẽ: Cầu dây văng Mỹ Thuận', N'Thư viện Kiến trúc', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 9, 'TL-002', 'REF 720', N'Tài liệu', 
N'Hồ sơ bản vẽ kỹ thuật chi tiết cầu Mỹ Thuận.'),

(N'Tuyển tập đề thi IELTS 2023', N'Cambridge', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 7, 'TL-004', 'REF 428', N'Tài liệu', 
N'Tổng hợp các đề thi IELTS thực tế (Academic & General) trong năm 2023.'),

(N'Đề thi TOEIC có giải chi tiết', N'ETS', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 7, 'TL-005', 'REF 428', N'Tài liệu', 
N'Bộ đề thi thử TOEIC format mới nhất kèm lời giải chi tiết.');
GO