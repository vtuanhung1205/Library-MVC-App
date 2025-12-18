PRAGMA foreign_keys = ON;

-- 1. Xóa dữ liệu cũ
DROP TABLE IF EXISTS "PhieuMuons";
DROP TABLE IF EXISTS "Sachs";
DROP TABLE IF EXISTS "TheLoais";
DROP TABLE IF EXISTS "NguoiDungs";

-- 2. Tạo bảng
CREATE TABLE "TheLoais" (
    "MaTheLoai" INTEGER NOT NULL CONSTRAINT "PK_TheLoais" PRIMARY KEY AUTOINCREMENT,
    "TenTheLoai" TEXT NOT NULL
);

CREATE TABLE "Sachs" (
    "MaSach" INTEGER NOT NULL CONSTRAINT "PK_Sachs" PRIMARY KEY AUTOINCREMENT,
    "TenSach" TEXT NOT NULL,
    "TacGia" TEXT NULL,
    "Gia" DECIMAL(18, 2) NOT NULL DEFAULT 0,
    "AnhBia" TEXT NULL,
    "ISBN" TEXT NULL,
    "NhaXuatBan" TEXT NULL,
    "NamXuatBan" INTEGER NOT NULL DEFAULT 2000,
    "SoHieu" TEXT NULL,
    "TomTat" TEXT NULL,
    "CoSan" INTEGER NOT NULL DEFAULT 1,
    "MaTheLoai" INTEGER NOT NULL,
    "LoaiTaiLieu" TEXT NOT NULL DEFAULT 'Sách',
    "SoLuong" INTEGER NOT NULL DEFAULT 5,
    "DaMuon" INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT "FK_Sachs_TheLoais_MaTheLoai" FOREIGN KEY ("MaTheLoai") REFERENCES "TheLoais" ("MaTheLoai") ON DELETE CASCADE
);

CREATE TABLE "NguoiDungs" (
    "MaNguoiDung" INTEGER NOT NULL CONSTRAINT "PK_NguoiDungs" PRIMARY KEY AUTOINCREMENT,
    "HoTen" TEXT NOT NULL,
    "Email" TEXT NOT NULL,
    "MatKhau" TEXT NOT NULL,
    "VaiTro" TEXT DEFAULT 'User'
);

CREATE TABLE "PhieuMuons" (
    "MaPhieu" INTEGER NOT NULL CONSTRAINT "PK_PhieuMuons" PRIMARY KEY AUTOINCREMENT,
    "MaSach" INTEGER NOT NULL,
    "MaNguoiDung" INTEGER NOT NULL,
    "NgayMuon" TEXT NOT NULL,
    "HanTra" TEXT NOT NULL,
    "TrangThai" INTEGER NOT NULL DEFAULT 0,
    "TienPhat" DECIMAL(18, 2) NOT NULL DEFAULT 0,
    "SoLanGiaHan" INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT "FK_PhieuMuons_Sachs" FOREIGN KEY ("MaSach") REFERENCES "Sachs" ("MaSach") ON DELETE CASCADE,
    CONSTRAINT "FK_PhieuMuons_NguoiDungs" FOREIGN KEY ("MaNguoiDung") REFERENCES "NguoiDungs" ("MaNguoiDung") ON DELETE CASCADE
);

-- ==========================================
-- DATA SEEDING
-- ==========================================

INSERT INTO "TheLoais" ("TenTheLoai") VALUES 
('Công Nghệ Thông Tin'), ('Kinh Tế & Quản Trị'), ('Văn Học & Tiểu Thuyết'), ('Kỹ Năng Sống'), 
('Khoa Học Cơ Bản'), ('Chính Trị & Pháp Luật'), ('Ngoại Ngữ'), ('Truyện Tranh'), 
('Kiến Trúc & Xây Dựng'), ('Y Học');

INSERT INTO "NguoiDungs" ("HoTen", "Email", "MatKhau", "VaiTro") VALUES 
('Quản Trị Viên', 'admin@gmail.com', '123456', 'Admin'),
('Sinh Viên A', 'user@gmail.com', '123456', 'User');

-- ============================================================
-- 1. SÁCH CÔNG NGHỆ THÔNG TIN (ID 1)
-- ============================================================
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "TomTat") VALUES
('Clean Code', 'Robert C. Martin', 850000, 'https://m.media-amazon.com/images/I/41xShlnTZTL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0132350884', '005.1 MAR', 'Sách', 
'Cuốn sách kinh điển về phát triển phần mềm linh hoạt. Tác giả đưa ra các nguyên tắc, mẫu thiết kế và thực hành tốt nhất để viết mã sạch, dễ đọc, dễ bảo trì và mở rộng.'),

('The Pragmatic Programmer', 'David Thomas', 920000, 'https://m.media-amazon.com/images/I/51IA4hT6jrL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0201616224', '005.1 THO', 'Sách', 
'Khám phá cốt lõi của quy trình phát triển phần mềm. Sách cung cấp những lời khuyên thực tế về mọi khía cạnh của lập trình.'),

('Design Patterns', 'Erich Gamma', 890000, 'https://m.media-amazon.com/images/I/51szD9HC9pL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0201633610', '005.1 GAM', 'Sách', 
'Cuốn sách nền tảng về các mẫu thiết kế hướng đối tượng. Giới thiệu 23 mẫu thiết kế kinh điển giúp giải quyết các vấn đề phổ biến.'),

('Introduction to Algorithms', 'Thomas H. Cormen', 1200000, 'https://m.media-amazon.com/images/I/41SNoh5ZhOL._SX218_BO1,204,203,200_QL40_FMwebp_.jpg', 1, '978-0262033848', '005.1 COR', 'Sách', 
'Được mệnh danh là Kinh thánh về thuật toán. Sách bao gồm đầy đủ các thuật toán từ cơ bản đến nâng cao.'),

('Head First Java', 'Kathy Sierra', 750000, 'https://m.media-amazon.com/images/I/81wAshyxQyL._UF1000,1000_QL80_.jpg', 1, '978-0596009205', '005.133 SIE', 'Sách', 
'Cách tiếp cận học Java hoàn toàn mới mẻ và trực quan. Sử dụng hình ảnh, câu đố và ví dụ thực tế thay vì văn bản khô khan.'),

('Code Complete 2', 'Steve McConnell', 950000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ9ekd9M4F56LNOq5Sy2Q20iiQXlZp-JB43A&s', 1, '978-0735619678', '005.1 MCC', 'Sách', 
'Cẩm nang toàn diện về xây dựng phần mềm. Sách tổng hợp các kỹ thuật thực tế tốt nhất trong việc thiết kế, viết code, debug và kiểm thử.'),

('Refactoring', 'Martin Fowler', 880000, 'https://martinfowler.com/books/refact2.jpg', 1, '978-0201485677', '005.1 FOW', 'Sách', 
'Hướng dẫn chi tiết về kỹ thuật tái cấu trúc mã nguồn. Cách cải thiện thiết kế của code hiện có mà không làm thay đổi hành vi bên ngoài.'),

('The Mythical Man-Month', 'Frederick Brooks', 600000, 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1348430512i/13629.jpg', 1, '978-0201835953', '005.1 BRO', 'Sách', 
'Tập hợp các bài luận kinh điển về kỹ nghệ phần mềm. Nổi tiếng với định luật Brooks.'),

('You Dont Know JS', 'Kyle Simpson', 450000, 'https://m.media-amazon.com/images/I/817kywRJjVL._AC_UF1000,1000_QL80_.jpg', 1, '978-1491904244', '005.133 SIM', 'Sách', 
'Bộ sách đi sâu vào các cơ chế cốt lõi của JavaScript như Scope, Closures, this, Object Prototypes.'),

('Python Crash Course', 'Eric Matthes', 550000, 'https://m.media-amazon.com/images/I/71uiG3qqKaL._AC_UF1000,1000_QL80_.jpg', 1, '978-1593276034', '005.133 MAT', 'Sách', 
'Sách nhập môn Python bán chạy nhất thế giới. Đi từ các khái niệm cơ bản đến các dự án thực tế.');

-- ============================================================
-- 2. SÁCH KINH TẾ (ID 2)
-- ============================================================
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "TomTat") VALUES
('Rich Dad Poor Dad', 'Robert T. Kiyosaki', 150000, 'https://m.media-amazon.com/images/I/81bsw6fnUiL._SY466_.jpg', 2, '978-1612680194', '332.024 KIY', 'Sách', 
'Cuốn sách tài chính cá nhân số 1 mọi thời đại. Tác giả chia sẻ những bài học về tiền bạc mà người giàu dạy con cái họ.'),

('Thinking, Fast and Slow', 'Daniel Kahneman', 250000, 'https://m.media-amazon.com/images/I/61fdrEuPJwL._SY466_.jpg', 2, '978-0374533557', '153.4 KAH', 'Sách', 
'Khám phá hai hệ thống tư duy điều khiển cách chúng ta suy nghĩ: Hệ thống 1 nhanh, trực quan và cảm tính; Hệ thống 2 chậm, cân nhắc và logic.'),

('Zero to One', 'Peter Thiel', 180000, 'https://m.media-amazon.com/images/I/71uAI28kJuL._SY466_.jpg', 2, '978-0804139298', '658.11 THI', 'Sách', 
'Ghi chép về khởi nghiệp và cách xây dựng tương lai. Peter Thiel lập luận rằng sự tiến bộ đến từ việc độc quyền và tạo ra những cái mới.'),

('The Lean Startup', 'Eric Ries', 190000, 'https://m.media-amazon.com/images/I/81-QB7nDh4L._SY466_.jpg', 2, '978-0307887894', '658.11 RIE', 'Sách', 
'Phương pháp khởi nghiệp tinh gọn giúp các doanh nhân xây dựng công ty hiệu quả hơn bằng cách liên tục kiểm thử, đo lường và cải tiến sản phẩm.'),

('Principles', 'Ray Dalio', 300000, 'https://themanreadthebook.com/images/books/1704548487-cover.jpg.jpg', 2, '978-1501124020', '658.4 DAL', 'Sách', 
'Ray Dalio chia sẻ những nguyên tắc sống và làm việc độc đáo đã giúp ông xây dựng Bridgewater Associates thành quỹ đầu cơ lớn nhất thế giới.'),

('Shoe Dog', 'Phil Knight', 220000, 'https://bizweb.dktcdn.net/100/326/228/products/shoedogphilknight-fa6d2bc8-30db-491b-9215-c92588ad9285.png?v=1540289795443', 2, '978-1501135910', '338.7 KNI', 'Sách', 
'Hồi ký đầy cảm hứng của nhà sáng lập Nike. Câu chuyện chân thực về hành trình khởi nghiệp đầy gian nan.'),

('The Intelligent Investor', 'Benjamin Graham', 280000, 'https://m.media-amazon.com/images/I/91+t0Di07FL._SY466_.jpg', 2, '978-0060555665', '332.6 GRA', 'Sách', 
'Cuốn sách gối đầu giường của Warren Buffett. Giới thiệu triết lý đầu tư giá trị, giúp nhà đầu tư tránh những sai lầm nghiêm trọng.'),

('Marketing 4.0', 'Philip Kotler', 160000, 'https://m.media-amazon.com/images/I/71DccJGxsKL._AC_UF1000,1000_QL80_.jpg', 2, '978-1119341208', '658.8 KOT', 'Sách', 
'Dịch chuyển từ tiếp thị truyền thống sang kỹ thuật số. Sách hướng dẫn cách doanh nghiệp tương tác với khách hàng trong thời đại kết nối.');

-- ============================================================
-- 3. VĂN HỌC (ID 3)
-- ============================================================
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "TomTat") VALUES
('Harry Potter 1', 'J.K. Rowling', 300000, 'https://m.media-amazon.com/images/I/71-++hbbERL._SY466_.jpg', 3, '978-0590353427', '823.914 ROW', 'Sách', 
'Tập đầu tiên trong bộ truyện lừng danh. Harry Potter, một cậu bé mồ côi, phát hiện ra mình là phù thủy và nhập học tại trường Hogwarts.'),

('The Alchemist', 'Paulo Coelho', 79000, 'https://m.media-amazon.com/images/I/71aFt4+OTOL._SY466_.jpg', 3, '978-0061122415', '869.3 COE', 'Sách', 
'Câu chuyện ngụ ngôn về Santiago, một chàng chăn cừu trẻ tuổi đi tìm kho báu. Cuốn sách là bài học sâu sắc về việc lắng nghe trái tim.'),

('The Great Gatsby', 'F. Scott Fitzgerald', 120000, 'https://m.media-amazon.com/images/I/71FTb9X6wsL._SY466_.jpg', 3, '978-0743273565', '813.52 FIT', 'Sách', 
'Bức tranh về Giấc mơ Mỹ thời đại Jazz. Qua lời kể của Nick Carraway, câu chuyện về đại gia Gatsby bí ẩn và mối tình ám ảnh với Daisy Buchanan.'),

('To Kill a Mockingbird', 'Harper Lee', 130000, 'https://m.media-amazon.com/images/I/81gepf1eMqL._SY466_.jpg', 3, '978-0061120084', '813.54 LEE', 'Sách', 
'Một tác phẩm kinh điển về nạn phân biệt chủng tộc và sự mất mát của sự ngây thơ ở miền Nam nước Mỹ thập niên 1930.'),

('1984', 'George Orwell', 110000, 'https://m.media-amazon.com/images/I/71kxa1-0mfL._SY466_.jpg', 3, '978-0451524935', '823.912 ORW', 'Sách', 
'Tiểu thuyết phản địa đàng mô tả một xã hội toàn trị dưới sự giám sát của Anh Cả. Một lời cảnh báo rùng rợn về quyền lực.'),

('Pride and Prejudice', 'Jane Austen', 100000, 'https://m.media-amazon.com/images/I/71Q1tPupKjL._SY466_.jpg', 3, '978-1503290563', '823.7 AUS', 'Sách', 
'Câu chuyện tình yêu lãng mạn và hài hước giữa Elizabeth Bennet thông minh và quý ngài Darcy kiêu ngạo.'),

('The Catcher in the Rye', 'J.D. Salinger', 115000, 'https://m.media-amazon.com/images/I/7108sdEUEGL._SY466_.jpg', 3, '978-0316769488', '813.54 SAL', 'Sách', 
'Hành trình của Holden Caulfield, một thiếu niên nổi loạn lang thang ở New York sau khi bị đuổi học.'),

('The Hobbit', 'J.R.R. Tolkien', 140000, 'https://m.media-amazon.com/images/I/712cDO7d73L._SY466_.jpg', 3, '978-0547928227', '823.912 TOL', 'Sách', 
'Câu chuyện về Bilbo Baggins, một người Hobbit thích yên bình, bị cuốn vào cuộc phiêu lưu giành lại kho báu từ rồng Smaug.');

-- ============================================================
-- 4. TRUYỆN TRANH (ID 8)
-- ============================================================
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "TomTat") VALUES
('Naruto Vol 1', 'Masashi Kishimoto', 25000, 'https://m.media-amazon.com/images/I/912xRMMra4L._SY466_.jpg', 8, '978-1569319000', '741.5 KIS', 'Sách', 
'Khởi đầu hành trình của Naruto Uzumaki, một ninja trẻ tuổi hiếu động luôn muốn tìm cách khẳng định mình và trở thành Hokage.'),

('One Piece Vol 1', 'Eiichiro Oda', 25000, 'https://m.media-amazon.com/images/I/91d0K2O-xCL._SY466_.jpg', 8, '978-1569319017', '741.5 ODA', 'Sách', 
'Luffy Mũ Rơm ra khơi để tìm kiếm kho báu huyền thoại One Piece và trở thành Vua Hải Tặc.'),

('Dragon Ball Vol 1', 'Akira Toriyama', 25000, 'https://m.media-amazon.com/images/I/81-1jqVHePL._AC_UF1000,1000_QL80_.jpg', 8, '978-1569319208', '741.5 TOR', 'Sách', 
'Goku, một cậu bé có đuôi khỉ, gặp gỡ Bulma và cùng nhau lên đường tìm kiếm 7 viên ngọc rồng có khả năng ban điều ước.'),

('Attack on Titan 1', 'Hajime Isayama', 30000, 'https://m.media-amazon.com/images/I/81qPzeEO5IL._AC_UF1000,1000_QL80_.jpg', 8, '978-1612620244', '741.5 ISA', 'Sách', 
'Nhân loại sống trong các bức tường để trốn tránh những người khổng lồ ăn thịt người. Eren Yeager thề sẽ tiêu diệt tất cả Titan.'),

('Death Note Vol 1', 'Tsugumi Ohba', 30000, 'https://prodimage.images-bn.com/pimages/9781421501680_p0_v4_s1200x630.jpg', 8, '978-1421501680', '741.5 OHB', 'Sách', 
'Light Yagami nhặt được cuốn sổ tử thần, cho phép giết bất cứ ai bị ghi tên vào đó. Cuộc đấu trí căng thẳng giữa Light và thám tử thiên tài L.'),

('Fullmetal Alchemist 1', 'Hiromu Arakawa', 30000, 'https://m.media-amazon.com/images/I/61yvu+BbxvL._AC_UF1000,1000_QL80_.jpg', 8, '978-1591169208', '741.5 ARA', 'Sách', 
'Hai anh em Edward và Alphonse Elric sử dụng giả kim thuật để hồi sinh mẹ nhưng thất bại thảm hại.'),

('Demon Slayer 1', 'Koyoharu Gotouge', 30000, 'https://m.media-amazon.com/images/I/811qqEcEywL._AC_UF1000,1000_QL80_.jpg', 8, '978-1974700523', '741.5 GOT', 'Sách', 
'Tanjiro trở thành thợ săn quỷ để tìm cách biến em gái Nezuko trở lại thành người sau khi gia đình cậu bị quỷ sát hại.'),

('My Hero Academia 1', 'Kohei Horikoshi', 30000, 'https://m.media-amazon.com/images/I/81AjnD8nvHL._AC_UF1000,1000_QL80_.jpg', 8, '978-1421582696', '741.5 HOR', 'Sách', 
'Trong thế giới mà ai cũng có siêu năng lực, Midoriya Izuku lại sinh ra vô năng. Tuy nhiên, cậu vẫn mơ ước trở thành anh hùng.');

-- ============================================================
-- 5. GIÁO TRÌNH (TEXTBOOKS)
-- ============================================================
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "TomTat") VALUES
('Giáo trình Triết học Mác - Lênin', 'Bộ Giáo Dục', 45000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfRH4wzcFFx1znMlUu9vE3RLui37MDkVnp7w&s', 6, 'GT-001', '335.4 MAC', 'Giáo trình', 
'Tài liệu học tập chính thức dùng cho sinh viên đại học, cao đẳng. Cung cấp hệ thống kiến thức cơ bản về chủ nghĩa duy vật biện chứng.'),

('Giáo trình Kinh tế Chính trị', 'Bộ Giáo Dục', 42000, 'https://www.nxbctqg.org.vn/img_data/images/036272640018_b1.jpg', 6, 'GT-002', '330 MAC', 'Giáo trình', 
'Trình bày các quy luật kinh tế cơ bản của phương thức sản xuất tư bản chủ nghĩa và những vấn đề kinh tế chính trị.'),

('Giáo trình Chủ nghĩa Xã hội Khoa học', 'Bộ Giáo Dục', 38000, 'https://www.nxbctqg.org.vn/img_data/images/326523824123_b1.jpg', 6, 'GT-003', '335 CNX', 'Giáo trình', 
'Nghiên cứu về sứ mệnh lịch sử của giai cấp công nhân và quá trình hình thành, phát triển của hình thái kinh tế - xã hội cộng sản chủ nghĩa.'),

('Giáo trình Tư tưởng Hồ Chí Minh', 'Bộ Giáo Dục', 35000, 'https://www.nxbctqg.org.vn/img_data/images/238626889476_ttkc.jpg', 6, 'GT-004', '335.43 HCM', 'Giáo trình', 
'Hệ thống quan điểm toàn diện và sâu sắc về những vấn đề cơ bản của cách mạng Việt Nam.'),

('Giáo trình Pháp luật Đại cương', 'ĐH Luật', 55000, 'https://www.nxbctqg.org.vn/img_data/images/328595209318_gia%CC%81o-tri%CC%80nh-pha%CC%81p-lua%CC%A3t-da%CC%A3i-cuong.jpg', 6, 'GT-006', '340 PLD', 'Giáo trình', 
'Cung cấp những kiến thức cơ bản nhất về Nhà nước và Pháp luật, là môn học bắt buộc cho sinh viên năm nhất.'),

('Giáo trình Toán Cao Cấp A1', 'Nguyễn Đình Trí', 50000, 'https://thuvienvatly.com/home/images/download_thumb/10WP2VIwyczvgkdtF9NAU7pQDOXfKT7qF.jpg', 5, 'GT-007', '510 TRI', 'Giáo trình', 
'Giáo trình dành cho sinh viên các khối kỹ thuật. Nội dung bao gồm: Giới hạn, Hàm số một biến số, Phép tính vi phân và tích phân.'),

('Giáo trình Đại số Tuyến tính', 'ĐH Bách Khoa', 48000, 'https://images.nxbbachkhoa.vn/Picture/2023/8/30/image-20230830145709651.jpg', 5, 'GT-009', '512 DST', 'Giáo trình', 
'Nghiên cứu về không gian vector, ma trận, định thức và hệ phương trình tuyến tính.'),

('Giáo trình Xác suất Thống kê', 'ĐH Kinh Tế', 55000, 'https://images.nxbbachkhoa.vn/Picture/2022/8/12/image-202208121134579.jpg', 5, 'GT-010', '519 XST', 'Giáo trình', 
'Cung cấp các công cụ toán học để xử lý dữ liệu, phân tích rủi ro và đưa ra dự báo.'),

('Giáo trình Vật lý Đại cương 1', 'Lương Duyên Bình', 60000, 'https://tailieuvnu.com/wp-content/uploads/2020/11/30/Giao-trinh-Vat-ly-dai-cuong-tap-1-Luong-Duyen-Binh.png', 5, 'GT-011', '530 BIN', 'Giáo trình', 
'Nội dung về Cơ học, Nhiệt học và Động lực học chất điểm.'),

('Giáo trình Hóa học Đại cương', 'Lâm Ngọc Thiềm', 58000, 'https://i.pinimg.com/474x/11/15/22/111522caec8e39207074413e3c0de942.jpg', 5, 'GT-012', '540 THI', 'Giáo trình', 
'Kiến thức nền tảng về cấu tạo chất, nhiệt động học hóa học và động hóa học.'),

('Giáo trình Nhập môn Lập trình C/C++', 'ĐH KHTN', 65000, 'https://images.vnuhcmpress.edu.vn/Picture/2025/11/10/image-20251110090133270.jpg', 1, 'GT-013', '005.13 KHT', 'Giáo trình', 
'Tài liệu nhập môn cho sinh viên CNTT. Giới thiệu tư duy lập trình cấu trúc, các kiểu dữ liệu, vòng lặp, hàm.'),

('Giáo trình Cấu trúc dữ liệu & Giải thuật', 'Đỗ Xuân Lôi', 70000, 'https://salt.tikicdn.com/cache/w1200/ts/product/18/36/52/329126ad0de0101a85dce7460df2aec7.jpg', 1, 'GT-014', '005.73 LOI', 'Giáo trình', 
'Môn học cốt lõi của ngành CNTT. Nghiên cứu các cấu trúc lưu trữ dữ liệu như Danh sách liên kết, Cây, Đồ thị.'),

('Giáo trình Cơ sở dữ liệu', 'ĐH Bách Khoa', 68000, 'https://images.nxbbachkhoa.vn/Picture/2024/5/8/image-20240508161021118.jpg', 1, 'GT-015', '005.74 CSD', 'Giáo trình', 
'Giới thiệu về mô hình dữ liệu quan hệ, ngôn ngữ SQL và thiết kế cơ sở dữ liệu chuẩn hóa.'),

('Giáo trình Mạng máy tính', 'Nguyễn Thúc Hải', 75000, 'https://images.nxbxaydung.com.vn/Picture/2025/3/13/image-20250313113450299.png', 1, 'GT-016', '004.6 HAI', 'Giáo trình', 
'Kiến thức về mô hình OSI, TCP/IP, các giao thức mạng và cách thức truyền tải dữ liệu trên Internet.'),

('Giáo trình Hệ điều hành', 'ĐH Công Nghệ', 72000, 'https://vietbooks.info/attachments/upload_2023-7-21_15-35-13-png.24762/', 1, 'GT-017', '005.43 HDH', 'Giáo trình', 
'Nghiên cứu cách quản lý tài nguyên máy tính, lập lịch tiến trình, quản lý bộ nhớ và hệ thống tập tin.'),

('Giáo trình Tiếng Anh B1', 'Oxford', 120000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0PM5JCfcYQbNzaLufJ6BgMq9_rdh-CqkKQQ&s', 7, 'GT-025', '428 OXF', 'Giáo trình', 
'Sách luyện thi và học tập tiếng Anh trình độ B1 theo khung tham chiếu Châu Âu (CEFR).'),

('Giáo trình Tiếng Anh B2', 'Cambridge', 130000, 'https://chungchitienganhtinhoc.net/wp-content/uploads/2023/01/sach-Compact-FCE.jpg', 7, 'GT-026', '428 CAM', 'Giáo trình', 
'Tài liệu nâng cao cho sinh viên chuyên ngữ, tập trung vào kỹ năng viết luận và thuyết trình.'),

('Giáo trình Tiếng Nhật Minna no Nihongo 1', '3A Network', 90000, 'https://static.oreka.vn/800-800_f45fdb2e-25af-44f5-91e7-bc71b492205f.jpg', 7, 'GT-027', '495.6 MIN', 'Giáo trình', 
'Giáo trình tiếng Nhật sơ cấp phổ biến nhất thế giới, dành cho người mới bắt đầu.'),

('Giáo trình Tiếng Trung Hán Ngữ 1', 'ĐH Bắc Kinh', 85000, 'https://static.oreka.vn/800-800_c30e174b-343a-41de-89af-28993a747428.webp', 7, 'GT-028', '495.1 HAN', 'Giáo trình', 
'Bộ giáo trình chuẩn để học tiếng Trung Quốc, tập trung vào phát âm và chữ Hán cơ bản.'),

('Giáo trình Giải phẫu người', 'Trịnh Văn Minh', 150000, 'https://testyhoc.vn/wp-content/uploads/2024/05/Giai-phau-nguoi-trinh-van-minh-tap-1.jpg', 10, 'GT-030', '611 GPN', 'Giáo trình', 
'Tài liệu kinh điển cho sinh viên Y khoa. Mô tả chi tiết cấu trúc giải phẫu cơ thể người.'),

('Giáo trình Sinh lý học', 'ĐH Y Hà Nội', 140000, 'https://testyhoc.vn/wp-content/uploads/2023/11/sinh-ly-hoc-y-ha-noi.jpg', 10, 'GT-031', '612 SLH', 'Giáo trình', 
'Nghiên cứu chức năng và hoạt động của các cơ quan trong cơ thể người.');

-- ============================================================
-- 6. TÀI LIỆU / LUẬN VĂN (DOCUMENTS)
-- ============================================================
INSERT INTO "Sachs" ("TenSach", "TacGia", "Gia", "AnhBia", "MaTheLoai", "ISBN", "SoHieu", "LoaiTaiLieu", "TomTat") VALUES
('Đồ án: Xây dựng website bán hàng MVC', 'Nguyễn Văn A (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2023-01', 'LV.2023.01', 'Tài liệu', 
'Đồ án tốt nghiệp kỹ sư CNTT. Đề tài nghiên cứu và xây dựng hệ thống thương mại điện tử sử dụng công nghệ ASP.NET Core MVC.'),

('Đồ án: Ứng dụng AI nhận diện khuôn mặt', 'Trần Thị B (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2023-02', 'LV.2023.02', 'Tài liệu', 
'Nghiên cứu các thuật toán Deep Learning (CNN) để nhận diện khuôn mặt trong hệ thống chấm công.'),

('Đồ án: Hệ thống quản lý thư viện', 'Lê Văn C (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'DA-2022-05', 'LV.2022.05', 'Tài liệu', 
'Xây dựng phần mềm quản lý thư viện trường đại học, tích hợp chức năng mượn trả sách tự động.'),

('Luận văn Thạc sĩ: Big Data trong Y tế', 'ThS. Nguyễn Văn X', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'LV-2021-01', 'LV.2021.01', 'Tài liệu', 
'Ứng dụng công nghệ Big Data để phân tích hồ sơ bệnh án điện tử và dự đoán dịch bệnh.'),

('Báo cáo thực tập: Công ty FPT Software', 'Sinh viên K15', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 1, 'BC-2023-10', 'BC.2023.10', 'Tài liệu', 
'Báo cáo quá trình thực tập tại vị trí Java Developer tại FPT Software.'),

('Luận văn: Phân tích tài chính Vinamilk', 'Lê Thị E (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'LV-2022-08', 'LV.2022.08', 'Tài liệu', 
'Phân tích các chỉ số tài chính, khả năng thanh khoản và hiệu quả hoạt động của công ty Vinamilk.'),

('Đồ án: Chiến lược Marketing Shopee', 'Hoàng Văn F (K15)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'DA-2023-05', 'LV.2023.05', 'Tài liệu', 
'Phân tích chiến lược Marketing Mix (4P) của Shopee tại thị trường Việt Nam.'),

('Nghiên cứu: Hành vi tiêu dùng Gen Z', 'Nhóm SV K16', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 2, 'NC-2024-02', 'NC.2024.02', 'Tài liệu', 
'Khảo sát thói quen mua sắm trực tuyến của thế hệ Z tại Hà Nội.'),

('Luận văn: Pháp luật về đất đai 2023', 'Nguyễn Thị G (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 6, 'LV-2022-12', 'LV.2022.12', 'Tài liệu', 
'Nghiên cứu những điểm mới trong Luật Đất đai sửa đổi năm 2023.'),

('Tuyển tập văn bản Luật Dân sự', 'Thư viện Luật', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 6, 'TL-001', 'REF 340', 'Tài liệu', 
'Tổng hợp các văn bản dưới luật hướng dẫn thi hành Bộ luật Dân sự 2015.'),

('Luận văn: Điều trị tiểu đường Type 2', 'BS. Lê Văn H', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 10, 'LV-2021-09', 'LV.2021.09', 'Tài liệu', 
'Nghiên cứu phác đồ điều trị mới cho bệnh nhân tiểu đường tuýp 2 tại bệnh viện Bạch Mai.'),

('Đồ án: Thiết kế chung cư 20 tầng', 'Phạm Văn I (K14)', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 9, 'DA-2022-06', 'LV.2022.06', 'Tài liệu', 
'Bản vẽ thiết kế kiến trúc và kết cấu cho tòa nhà chung cư cao tầng.'),

('Bản vẽ: Cầu dây văng Mỹ Thuận', 'Thư viện Kiến trúc', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 9, 'TL-002', 'REF 720', 'Tài liệu', 
'Hồ sơ bản vẽ kỹ thuật chi tiết cầu Mỹ Thuận.'),

('Tuyển tập đề thi IELTS 2023', 'Cambridge', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 7, 'TL-004', 'REF 428', 'Tài liệu', 
'Tổng hợp các đề thi IELTS thực tế (Academic & General) trong năm 2023.'),

('Đề thi TOEIC có giải chi tiết', 'ETS', 0, 'https://m.media-amazon.com/images/I/51+G+g+u+L._SY466_.jpg', 7, 'TL-005', 'REF 428', 'Tài liệu', 
'Bộ đề thi thử TOEIC format mới nhất kèm lời giải chi tiết.');