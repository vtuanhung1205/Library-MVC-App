using System;
using System.ComponentModel.DataAnnotations;

namespace library.Models
{
    public class Document
    {
        public int Id { get; set; }

        [Required]
        public string Title { get; set; }

        public string FileName { get; set; }

        [Display(Name = "Upload Date")]
        public DateTime UploadDate { get; set; }
    }
}