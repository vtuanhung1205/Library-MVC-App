using Microsoft.EntityFrameworkCore; // <--- THIS LINE IS REQUIRED
using WebsiteQlyThuVien.Models;

namespace WebsiteQlyThuVien.Data;

public class LibraryDbContext : DbContext
{
    public LibraryDbContext(DbContextOptions<LibraryDbContext> options) : base(options)
    {
    }

    public DbSet<Book> Books { get; set; }
}