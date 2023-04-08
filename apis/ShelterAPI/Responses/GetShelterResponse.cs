using DatabaseContextLibrary.models;
using ShelterAPI.Data;

namespace ShelterAPI.Responses
{
    public class GetShelterResponse
    {
        public Guid Id { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string FullShelterName { get; set; }
        public bool IsAuthorized { get; set; }
        public AddressDTO Address { get; set; }

        public GetShelterResponse()
        {
        }

        public GetShelterResponse(Shelter shelter)
        {
            Id = shelter.Id;
            UserName = shelter.UserName;
            PhoneNumber = shelter.PhoneNumber;
            Email = shelter.Email;
            FullShelterName = shelter.FullShelterName;
            IsAuthorized = shelter.IsAuthorized;
            Address = shelter.Address.MapDTO();
        }
    }
}
