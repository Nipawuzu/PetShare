using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace DatabaseContextLibrary.models
{
    public class Report
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid Id { get; set; }
        public Guid TargetId { get; set; }
        public ReportType ReportType { get; set; }
        public string? Message { get; set; }
        public ReportState State { get; set; }
    }

    public enum ReportType
    {
        Adopter,
        Announcement,
        Shelter
    }

    public enum ReportState
    {
        New,
        Accepted,
        Declined
    }
}
