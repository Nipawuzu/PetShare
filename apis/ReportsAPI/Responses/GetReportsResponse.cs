using CommonDTOLibrary.Models;

namespace ReportsAPI.Responses
{
    public class GetReportsResponse
    {
        public ReportDTO[] Reports { get; set; }
        public int PageNumber { get; set; }
        public int Count { get; set; }
    }
}
