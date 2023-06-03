using DatabaseContextLibrary.models;

namespace ReportsAPI.Requests
{
    public class PutReportRequest
    {
        public ReportState State { get; set; }
    }
}