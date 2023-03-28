using DatabaseContextLibrary.models;

namespace AnnouncementsAPI.Data
{
    public class AnnouncementDTO
    {
        public Guid Id { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime CreationDate { get; set; }
        public DateTime? ClosingDate { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public Status Status { get; set; }
        public PetDTO Pet { get; set; }
    }
}
