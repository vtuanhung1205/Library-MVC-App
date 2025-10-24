-- Chọn cơ sở dữ liệu QuanLySanPham
USE QuanLyThuVien;
GO
-- Tạo bảng Catalog
CREATE TABLE Catalog (
 Id INT IDENTITY(1,1) PRIMARY KEY,
 CatalogCode NVARCHAR(50) NOT NULL,
 CatalogName NVARCHAR(250) NULL
);
-- Tạo bảng Product
CREATE TABLE Product (
 Id INT IDENTITY(1,1) PRIMARY KEY,
 NumericalOrder INT FOREIGN KEY REFERENCES Catalog(Id),
 DocumentName NVARCHAR(50) NULL,
 DocumentType NVARCHAR(250) NULL,
 Author NVARCHAR(50) NULL,
 YearofPublication INT,
 ProductCode NVARCHAR(50) NULL,
 Picture NVARCHAR(MAX) NULL,
 UnitPrice FLOAT NULL,
 Status NVARCHAR(50) NULL,
);