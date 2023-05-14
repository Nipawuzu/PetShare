using DatabaseContextLibrary.models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseContextLibrary.Models
{
    [PrimaryKey(nameof(AdopterId), nameof(AnnouncementId))]
    public class AdopterLikedAnnouncementsLinkingTable
    {
        public Guid AdopterId { get; set; }

        public virtual Adopter Adopter { get; set; }

        public Guid AnnouncementId { get; set; }

        public virtual Announcement Announcement { get; set; }
    }
}
