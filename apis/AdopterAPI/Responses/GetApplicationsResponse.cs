using CommonDTOLibrary.Models;

namespace AdopterAPI.Responses
{
    public class GetApplicationsResponse : BasePaginationResponse
    {
        public ApplicationDTO[] Applications { get; set; }
    }
}
