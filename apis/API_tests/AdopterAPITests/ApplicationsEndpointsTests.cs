using AdopterAPI;
using System.Net;

namespace APIs_tests.AdopterAPITests
{
    public class ApplicationEndpointsTests : APITests<ProgramAdopterAPI, DataContext>
    {
        [Theory]
        [InlineData(NO_TOKEN, HttpStatusCode.Unauthorized)]
        [InlineData(ADOPTER_TOKEN, HttpStatusCode.OK)]
        [InlineData(SHELTER_TOKEN, HttpStatusCode.OK)]
        [InlineData(ADMIN_TOKEN, HttpStatusCode.OK)]
        public async void AuthIsNeededForApplicationGet(string? token, HttpStatusCode expStatus)
        {
            var getRequest = CreateRequest(HttpMethod.Get, Urls.Applications, authToken: token);
            var result = await client.SendAsync(getRequest);
            Assert.Equal(expStatus, result.StatusCode);
        }
    }
}
