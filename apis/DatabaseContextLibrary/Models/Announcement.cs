using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseContextLibrary.models
{
    public class Announcement
    {
        public Guid Id { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime CreationDate { get; set; }
        public DateTime? ClosingDate { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public Status Status { get; set; }
        public Guid PetId { get; set; }
        public Pet Pet { get; set; }
    }

    public enum Status
    {
        Open,
        Closed,
        DuringVerification,
        Deleted
    }
}
