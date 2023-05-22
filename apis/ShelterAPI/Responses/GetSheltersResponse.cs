using CommonDTOLibrary.Models;

namespace ShelterAPI.Responses
{
    public class GetSheltersResponse : BasePaginationResponse
    {
        public ShelterDTO[] Shelters { get; set; }
    }
}
