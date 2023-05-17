using CommonDTOLibrary.Models;

namespace AnnouncementsAPI.Responses
{
    public class GetAllLikedAnnouncementsResponse
    {
        public AnnouncementDTO[] Announcements
        {
            get; set;
        }

        public int PageNumber
        {
            get; set;
        }

        public int Count
        {
            get; set;
        }
    }
}
