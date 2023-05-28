namespace CommonDTOLibrary.Models
{
    public class ReportDTO
    {
        public Guid Id { get; set; }
        public Guid TargetId { get; set; }
        public ReportTypeDTO ReportType { get; set; }
        public string? Message { get; set; }
        public ReportStateDTO State { get; set; }
    }

    public enum ReportTypeDTO
    {
        Adopter,
        Announcement,
        Shelter
    }

    public enum ReportStateDTO
    {
        New,
        Accepted,
        Declined
    }
}
