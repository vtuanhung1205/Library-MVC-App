using library.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace library.Controllers
{
    public class DocumentsController : Controller
    {
        // Simulated database context
        private static List<Document> db = new List<Document>();
        private static int nextId = 1;

        // GET: /Documents or /Documents?search=...
        public ActionResult Index(string search)
        {
            var documents = from d in db select d;

            if (!String.IsNullOrEmpty(search))
            {
                documents = documents.Where(s => s.Title.Contains(search));
            }

            return View(documents.ToList());
        }

        // GET: /Documents/Details/5
        public ActionResult Details(int id)
        {
            var document = db.FirstOrDefault(d => d.Id == id);
            if (document == null)
            {
                return HttpNotFound();
            }
            return View(document);
        }

        // GET: /Documents/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: /Documents/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Document document, HttpPostedFileBase file)
        {
            if (ModelState.IsValid)
            {
                if (file != null && file.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(file.FileName);
                    // IMPORTANT: Create an "Uploads" folder in the root of your project.
                    var path = Path.Combine(Server.MapPath("~/Uploads/"), fileName);
                    file.SaveAs(path);

                    document.FileName = fileName;
                    document.UploadDate = DateTime.Now;
                    document.Id = nextId++; // Simple ID generation
                    db.Add(document);

                    return RedirectToAction("Index");
                }
                else
                {
                    ModelState.AddModelError("File", "Please upload a file.");
                }
            }

            return View(document);
        }

        // GET: /Documents/Download/5
        public ActionResult Download(int id)
        {
            var document = db.FirstOrDefault(d => d.Id == id);
            if (document == null)
            {
                return HttpNotFound();
            }

            var filePath = Path.Combine(Server.MapPath("~/Uploads/"), document.FileName);
            byte[] fileBytes = System.IO.File.ReadAllBytes(filePath);
            
            return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, document.FileName);
        }
    }
}