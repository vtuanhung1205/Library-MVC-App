-- Nhập dữ liệu vào bảng Catalog
INSERT INTO Catalog (CatalogCode, CatalogName) VALUES
('DM01', N'Sách'),
('DM02', N'Tài Liệu'),
('DM03', N'Giáo Trình');
-- Nhập dữ liệu vào bảng Product
INSERT INTO Product (NumericalOrder, DocumentName, DocumentType, Author, YearofPublication, ProductCode, Picture, UnitPrice, Status) VALUES
(3, N'Lập trình Python cơ bản', N'Giáo trình', N'Nguyễn Văn A', 2022, 'GT001', '1.PNG', 120000, N'Còn'),
(1, N'Tư duy phản biện', N'Sách', N'Trần Thị B', 2021, 'S002', '2.PNG', 350000, N'Hết'),
(2, N'Hướng dẫn viết báo cáo khoa học', N'Tài liệu', N'Lê Văn C', 2020, 'TL003', '3.PNG', 200000, N'Còn'),
(3, N'Cấu trúc dữ liệu và giải thuật', N'Giáo trình', N'Phạm Văn D', 2023, 'GT004', '4.PNG', 400000, N'Còn'),
(1, N'Lịch sử văn minh thế giới', N'Sách', N'Nguyễn Thị E', 2019, 'S005', '5.PNG', 100000, N'Hết'),
(2, N'Mẫu đề thi và đáp án môn Toán', N'Tài liệu', N'Bộ môn Toán học', 2024, 'TL006', '6.PNG', 150000, N'Còn'),
(1, N'Kỹ năng làm việc nhóm', N'Sách', N'Đinh Văn G', 2020, 'S007', '7.PNG', 300000, N'Còn'),
(3, N'Bài giảng Kinh tế vi mô', N'Giáo trình', N'ThS. Nguyễn Thị H', 2023, 'GT008', '8.PNG', 500000, N'Hết'),
(2, N'Phương pháp nghiên cứu khoa học', N'Tài liệu', N'TS. Lê Minh I', 2021, 'TL009', '9.PNG', 1000000, N'Còn'),
(3, N'Nhập môn Trí tuệ nhân tạo', N'Giáo trình', N'PGS.TS. Trần Văn J', 2022, 'GT010', '10.PNG', 1500000, N'Còn');