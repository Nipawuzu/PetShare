using CommonDTOLibrary.Models;

namespace ReportsAPI.Requests
{
    public class PostReportRequest
    {
        public Guid TargetId { get; set; }
        public ReportTypeDTO ReportType { get; set; }
        public string? Message { get; set; }
    }
}
