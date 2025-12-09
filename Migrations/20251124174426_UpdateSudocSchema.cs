using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace QuanLyThuVien.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSudocSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Gia",
                table: "Sachs");

            migrationBuilder.AddColumn<bool>(
                name: "CoSan",
                table: "Sachs",
                type: "INTEGER",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "ISBN",
                table: "Sachs",
                type: "TEXT",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "NamXuatBan",
                table: "Sachs",
                type: "INTEGER",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "NhaXuatBan",
                table: "Sachs",
                type: "TEXT",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SoHieu",
                table: "Sachs",
                type: "TEXT",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "TomTat",
                table: "Sachs",
                type: "TEXT",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CoSan",
                table: "Sachs");

            migrationBuilder.DropColumn(
                name: "ISBN",
                table: "Sachs");

            migrationBuilder.DropColumn(
                name: "NamXuatBan",
                table: "Sachs");

            migrationBuilder.DropColumn(
                name: "NhaXuatBan",
                table: "Sachs");

            migrationBuilder.DropColumn(
                name: "SoHieu",
                table: "Sachs");

            migrationBuilder.DropColumn(
                name: "TomTat",
                table: "Sachs");

            migrationBuilder.AddColumn<decimal>(
                name: "Gia",
                table: "Sachs",
                type: "TEXT",
                nullable: false,
                defaultValue: 0m);
        }
    }
}
