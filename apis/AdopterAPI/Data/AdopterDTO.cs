using DatabaseContextLibrary.models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace AdopterAPI.Data
{
    public class AdopterDTO
    {
        public Guid Id { get; set; }
        public string? UserName { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Email { get; set; }
        public AddressDTO? Address { get; set; }
        public AdopterStatusDTO Status { get; set; }
    }

    public enum AdopterStatusDTO
    {
        Active,
        Blocked,
        Deleted
    }
}
