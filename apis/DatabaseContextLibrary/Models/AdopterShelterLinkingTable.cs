using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace DatabaseContextLibrary.models
{
    [PrimaryKey(nameof(AdopterId), nameof(ShelterId))]
    public class AdopterShelterLinkingTable
    {
        public Guid AdopterId { get; set; }

        public virtual Adopter Adopter { get; set; }

        public Guid ShelterId { get; set; }

        public virtual Shelter Shelter { get; set; }
    }
}
