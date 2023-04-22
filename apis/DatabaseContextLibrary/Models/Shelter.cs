namespace DatabaseContextLibrary.models
{
    public class Shelter
    {
        public Guid Id { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public Guid AddressId { get; set; }
        public string FullShelterName { get; set; }
        public bool IsAuthorized { get; set; } = false;
        public Address Address { get; set; }
    }
}
