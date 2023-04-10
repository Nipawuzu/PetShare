using DatabaseContextLibrary.models;

namespace AdoptersAPI.Requests
{
    public class PostApplicationRequest
    {
        public Guid? AnnouncementId { get; set; }
        public Guid? AdopterId { get; set; }
    }
}
