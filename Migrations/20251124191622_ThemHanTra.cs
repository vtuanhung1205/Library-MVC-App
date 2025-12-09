using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace QuanLyThuVien.Migrations
{
    /// <inheritdoc />
    public partial class ThemHanTra : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PhieuMuons",
                columns: table => new
                {
                    MaPhieu = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    MaSach = table.Column<int>(type: "INTEGER", nullable: false),
                    MaNguoiDung = table.Column<int>(type: "INTEGER", nullable: false),
                    NgayMuon = table.Column<DateTime>(type: "TEXT", nullable: false),
                    HanTra = table.Column<DateTime>(type: "TEXT", nullable: false),
                    TrangThai = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PhieuMuons", x => x.MaPhieu);
                    table.ForeignKey(
                        name: "FK_PhieuMuons_NguoiDungs_MaNguoiDung",
                        column: x => x.MaNguoiDung,
                        principalTable: "NguoiDungs",
                        principalColumn: "MaNguoiDung",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PhieuMuons_Sachs_MaSach",
                        column: x => x.MaSach,
                        principalTable: "Sachs",
                        principalColumn: "MaSach",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_PhieuMuons_MaNguoiDung",
                table: "PhieuMuons",
                column: "MaNguoiDung");

            migrationBuilder.CreateIndex(
                name: "IX_PhieuMuons_MaSach",
                table: "PhieuMuons",
                column: "MaSach");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PhieuMuons");
        }
    }
}
