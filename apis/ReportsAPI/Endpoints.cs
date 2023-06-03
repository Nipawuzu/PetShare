using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using CommonDTOLibrary.Mappers;
using ReportsAPI;
using ReportsAPI.Responses;
using ReportsAPI.Requests;

namespace Reports
{
    public static class Endpoints
    {
        private const int DEFAULT_PAGE_COUNT = 100;

        public static async Task<IResult> GetReports(DataContext context, int? pageNumber, int? pageCount)
        {
            var reports = context.Reports.Where(r => r.State == ReportState.New);

            int pageNumberVal = pageNumber ?? 0;
            int pageCountVal = pageCount ?? DEFAULT_PAGE_COUNT;

            int count = reports.Count();

            var res = await reports
                .Skip(pageNumberVal * pageCountVal).Take(pageCountVal)
                .Select(r => r.MapDTO()).ToArrayAsync();

            return Results.Ok(new GetReportsResponse()
            {
                Reports = res,
                PageNumber = pageNumberVal,
                Count = count
            });
        }

        public static async Task<IResult> AddReport(DataContext context, PostReportRequest report)
        {
            var newReport = report.Map();

            context.Reports.Add(newReport);
            await context.SaveChangesAsync();

            return Results.Created(newReport.Id.ToString(), null);
        }

        public static async Task<IResult> UpdateReport(DataContext context, Guid reportId, PutReportRequest updatedReport)
        {
            var report = await context.Reports.FirstOrDefaultAsync(s => s.Id == reportId);
            if (report is null)
                return Results.BadRequest("Sorry, this shelter doesn't exist.");

            report.State = updatedReport.State;
            await context.SaveChangesAsync();

            return Results.Ok(report);
        }
    }
}
