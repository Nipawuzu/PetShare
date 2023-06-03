using CommonDTOLibrary.Models;

namespace AnnouncementsAPI.Responses
{
    public class GetAnnouncementsReponse : BasePaginationResponse
    {
        public AnnouncementDTO[] Announcements { get; set; }
    }
}
