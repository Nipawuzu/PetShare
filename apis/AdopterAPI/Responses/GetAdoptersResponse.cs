using CommonDTOLibrary.Models;

namespace AdopterAPI.Responses
{
    public class GetAdoptersResponse : BasePaginationResponse
    {
        public AdopterDTO[] Adopters { get; set; }
    }
}
