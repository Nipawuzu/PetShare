using CommonDTOLibrary.Models;

namespace AdopterAPI.Requests
{
    public class PostAdopterRequest
    {
        public string? UserName { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Email { get; set; }
        public AddressDTO? Address { get; set; }
    }
}
