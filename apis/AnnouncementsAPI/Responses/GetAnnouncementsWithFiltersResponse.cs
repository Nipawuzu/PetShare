using CommonDTOLibrary.Models;

namespace AnnouncementsAPI.Responses
{
    public class GetAnnouncementsWithFiltersResponse
    {
        public Guid Id { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime CreationDate { get; set; }
        public DateTime? ClosingDate { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public AnnouncementStatusDTO Status { get; set; }
        public PetDTO Pet { get; set; }
        public bool IsLiked { get; set; }
    }
}
