namespace AnnouncementsAPI.Requests
{
    public class PostAnnouncementRequest
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public Guid PetId { get; set; }
    }
}
