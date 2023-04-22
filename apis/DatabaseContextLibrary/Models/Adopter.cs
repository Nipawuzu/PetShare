using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace DatabaseContextLibrary.models
{
    public class Adopter
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid Id { get; set; }
        public string? UserName { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Email { get; set; }
        public Guid AddressId { get; set; }
        public Address? Address { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public AdopterStatus Status { get; set; }
    }

    public enum AdopterStatus
    {
        Active,
        Blocked,
        Deleted
    }
}
