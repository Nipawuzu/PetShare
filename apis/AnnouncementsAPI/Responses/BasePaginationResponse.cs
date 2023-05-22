using CommonDTOLibrary.Models;

namespace AnnouncementsAPI.Responses
{
    public abstract class BasePaginationResponse
    {
        public int PageNumber { get; set; }
        public int Count { get; set; }
    }
}