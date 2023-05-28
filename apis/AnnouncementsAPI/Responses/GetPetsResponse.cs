using CommonDTOLibrary.Models;

namespace AnnouncementsAPI.Responses
{
    public class GetPetsResponse : BasePaginationResponse
    {
        public PetDTO[] Pets { get; set; }
    }
}
