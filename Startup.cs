using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using System;
using System.Runtime.InteropServices; // <--- QUAN TRỌNG: Thư viện để kiểm tra Windows/Linux
using QuanLyThuVien.Data;

namespace QuanLyThuVien
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // Hàm này dùng để thêm dịch vụ (Services)
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllersWithViews();

            // --- CẤU HÌNH TỰ ĐỘNG CHỌN DATABASE ---
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                // Nếu là Windows -> Dùng SQL Server
                // Chuỗi kết nối tên là "SqlServerConnection"
                services.AddDbContext<ThuVienContext>(options =>
                    options.UseSqlServer(Configuration.GetConnectionString("SqlServerConnection")));
            }
            else
            {
                // Nếu là Linux (POP_OS) hoặc Mac -> Dùng SQLite
                // Chuỗi kết nối tên là "SqliteConnection"
                services.AddDbContext<ThuVienContext>(options =>
                    options.UseSqlite(Configuration.GetConnectionString("SqliteConnection")));
            }
            // ---------------------------------------

            services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
                .AddCookie(options =>
                {
                    options.LoginPath = "/Account/Login";
                    options.ExpireTimeSpan = TimeSpan.FromMinutes(20);
                });
        }

        // Hàm này dùng để cấu hình HTTP Pipeline
        // Thêm tham số ThuVienContext context để tự động tạo DB
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ThuVienContext context)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            // --- TỰ ĐỘNG TẠO DATABASE NẾU CHƯA CÓ ---
            // Lệnh này giúp bạn không cần chạy migration thủ công khi đổi máy
            context.Database.EnsureCreated();
            // -----------------------------------------

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
            });
        }
    }
}