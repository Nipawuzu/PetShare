using CommonDTOLibrary.Models;

namespace ShelterAPI.Requests
{
    public class PostShelterRequest
    {
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string FullShelterName { get; set; }
        public AddressDTO Address { get; set; }
    }
}
