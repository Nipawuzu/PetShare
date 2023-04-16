using ShelterAPI.Data;

namespace ShelterAPI.Responses
{
    public class GetSheltersResponse
    {
        public ShelterDTO[] Shelters { get; set; }

        public GetSheltersResponse(ShelterDTO[] shelters)
        {
            Shelters = shelters;
        }
    }
}
