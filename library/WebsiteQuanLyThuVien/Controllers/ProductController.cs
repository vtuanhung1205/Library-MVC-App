using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using WebsiteQuanLyThuVien.Models;

namespace WebsiteQuanLyThuVien.Controllers
{
    public class ProductController : Controller
    {
        // GET: Product
        public ActionResult Index()
        {
            QuanLyThuVienDataContext context = new QuanLyThuVienDataContext();
            List<Product> dsProduct = context.Products.ToList();
            return View(dsProduct);
        }
    }
}