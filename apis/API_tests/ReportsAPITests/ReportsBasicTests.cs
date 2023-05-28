using CommonDTOLibrary.Models;
using DatabaseContextLibrary.models;
using FluentAssertions;
using Google.Cloud.Storage.V1;
using ReportsAPI;
using ReportsAPI.Requests;
using ReportsAPI.Responses;
using ShelterAPI.Requests;
using System.Net;

namespace APIs_tests.ReportsAPITests
{
    public class ReportsBasicTests : APITests<ProgramReportsAPI, DataContext>
    {
        [Theory]
        [MemberData(nameof(ReportDataGenerator))]
        public async Task<Guid> PostNewReport(ReportDTO report)
        {
            var postReportRequest = new PostReportRequest()
            {
                Message = report.Message,
                ReportType = report.ReportType,
                TargetId = report.TargetId,
            };

            var postRequest = CreateRequest(HttpMethod.Post, Urls.Reports, postReportRequest, ADMIN_TOKEN);
            var postResult = await PostRequest(postRequest);
            return postResult;
        }

        [Theory]
        [MemberData(nameof(ReportDataGenerator))]
        public async void PostAndGetNewReport(ReportDTO report)
        {
            var reportId = await PostNewReport(report);

            var getRequest = CreateRequest(HttpMethod.Get, $"{Urls.Reports}", authToken: ADMIN_TOKEN);
            var getResult = await SendRequest<GetReportsResponse>(getRequest);

            getResult.Reports.Should().ContainEquivalentOf(report, o => o.Excluding(x => x.Id).Excluding(x => x.State));
        }

        [Fact]
        public async void GetAllReports()
        {
            var getRequest = CreateRequest(HttpMethod.Get, Urls.Reports, authToken: ADMIN_TOKEN);
            await SendRequest<GetReportsResponse>(getRequest);
        }

        [Theory]
        [MemberData(nameof(ReportDataGenerator))]
        public async void PutShelter(ReportDTO report)
        {
            var reportId = await PostNewReport(report);
            var req = new PutReportRequest() { State = ReportState.Accepted };

            var putRequest = CreateRequest(HttpMethod.Put, $"{Urls.Reports}/{reportId}", req, authToken: ADMIN_TOKEN);
            var res = await this.client.SendAsync(putRequest);


            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        public static IEnumerable<object[]> ReportDataGenerator()
        {
            yield return new object[]
            {
                new ReportDTO
                {
                    Message = "Obraźliwa nazwa",
                    ReportType = ReportTypeDTO.Shelter,
                    State = ReportStateDTO.New,
                    TargetId = Guid.NewGuid(),
                }
            };
        }
    }
}
