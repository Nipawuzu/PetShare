using AnnouncementsAPI.Data;
using DatabaseContextLibrary.models;

namespace AnnouncementsAPI.Responses
{
    public class GetAnnouncementResponse
    {
        public Guid Id { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime CreationDate { get; set; }
        public DateTime? ClosingDate { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public Status Status { get; set; }
        public PetDTO Pet { get; set; }

        public GetAnnouncementResponse(Announcement announcement)
        {
            Id = announcement.Id;
            Title = announcement.Title;
            Description = announcement.Description;
            CreationDate = announcement.CreationDate;
            ClosingDate = announcement.ClosingDate;
            LastUpdateDate = announcement.LastUpdateDate;
            Status = announcement.Status;
            Pet = announcement.Pet.MapDTO();
        }
    }
}
