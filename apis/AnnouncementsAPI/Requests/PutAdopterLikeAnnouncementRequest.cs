namespace AnnouncementsAPI.Requests
{
    public class PutAdopterLikeAnnouncementRequest
    {
        public Guid AnnouncementId
        {
            get; set;
        }

        public bool IsLiked
        {
            get; set;
        }
    }
}
