using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace DatabaseContextLibrary.models
{
    public class Application
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid Id { get; set; }
        public DateTime? CreationDate { get; set; }
        public DateTime? LastUpdateDate { get; set; }
        public Guid AnnouncementId { get; set; }
        public virtual Announcement? Announcement { get; set; }
        public Guid AdopterId { get; set; }
        public virtual Adopter? Adopter { get; set; }
        public ApplicationStatus ApplicationStatus { get; set; }
    }

    public enum ApplicationStatus
    {
        Created,
        Accepted,
        Rejected,
        Withdrawn,
        Deleted
    }
}
