namespace CommonDTOLibrary.Models
{
    public class ApplicationDTO
    {
        public Guid Id { get; set; }
        public DateTime? CreationDate { get; set; }
        public DateTime? LastUpdateDate { get; set; }
        public Guid AnnouncementId { get; set; }
        public virtual AnnouncementDTO? Announcement { get; set; }
        public virtual AdopterDTO? Adopter { get; set; }
        public ApplicationStatusDTO ApplicationStatus { get; set; }
    }

    public enum ApplicationStatusDTO
    {
        Created,
        Accepted,
        Rejected,
        Withdrawn,
        Deleted
    }
}
