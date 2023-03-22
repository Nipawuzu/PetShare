namespace ShelterAPI.Requests
{
    public class PostShelterRequest
    {
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string FullShelterName { get; set; }
        public NewAddress Address { get; set; }
    }

    public class NewAddress
    {
        public string Street { get; set; }
        public string City { get; set; }
        public string Province { get; set; }
        public string PostalCode { get; set; }
        public string Country { get; set; }
    }
}