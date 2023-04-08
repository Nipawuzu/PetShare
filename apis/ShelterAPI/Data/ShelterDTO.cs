using DatabaseContextLibrary.models;

namespace ShelterAPI.Data
{
    public class ShelterDTO
    {
        public Guid Id { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string FullShelterName { get; set; }
        public bool IsAuthorized { get; set; }
        public AddressDTO Address { get; set; }
    }
}
