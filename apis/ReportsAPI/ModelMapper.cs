using CommonDTOLibrary.Mappers;
using DatabaseContextLibrary.models;
using ReportsAPI.Requests;

namespace ReportsAPI
{
    public static class ModelMapper
    {
        public static Report Map(this PostReportRequest reportRequest)
        {
            return new Report()
            {
                Message = reportRequest.Message,
                ReportType = reportRequest.ReportType.MapDTO<ReportType>(),
                TargetId = reportRequest.TargetId,
                State = ReportState.New
            };
        }
    }
}
