using DatabaseContextLibrary.models;

namespace AnnouncementsAPI.Requests
{
    public class PutAnnouncementRequest
    {
        public string? Title { get; set; }
        public string? Description { get; set; }
        public Guid? PetId { get; set; }
        public Status? Status { get; set; }
    }
}
