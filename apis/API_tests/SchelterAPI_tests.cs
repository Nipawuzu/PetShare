using DatabaseContextLibrary.models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestPlatform.TestHost;
using Newtonsoft.Json;
using ShelterAPI;
using System.Net;
using System.Net.Http.Json;
using System.Reflection;
using System.Text;
using System.Text.Json;

namespace API_tests
{
    public class SchelterAPI_tests
    {
        private const string SHELTER_AUTH = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIzZmE4NWY2NC01NzE3LTQ1NjItYjNmYy0yYzk2M2Y2NmFmYTYiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiU2hlbHRlciJdfQ.E2872Rdzn0qvJnjXn_rJA-IHSQm4Nqu49OHlkfhUbe8";

        WebApplicationFactory<ProgramShelterAPI> application;
        HttpClient client;

        public SchelterAPI_tests()
        {
            application = new WebApplicationFactory<ProgramShelterAPI>()
               .WithWebHostBuilder(builder => builder
                   .ConfigureServices(services =>
                   {
                       var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<DataContext>));

                       if (descriptor != null)
                       {
                           services.Remove(descriptor);
                       }

                       services.AddDbContext<DataContext>(opt => opt.UseInMemoryDatabase("ShelterTestsDB"));
                   }));

            client = application.CreateClient();
        }


        [Theory]
        [MemberData(nameof(TestData))]
        public async void SchelterApiAnablesAddNewSchelterWithPostRequest(Shelter shelter)
        {
            var postRequest = CreateRequest(HttpMethod.Post, "/shelter", JsonConvert.SerializeObject(shelter), SHELTER_AUTH);
            var postResult = await client.SendAsync(postRequest);

            Assert.Equal(HttpStatusCode.OK, postResult.StatusCode);

            var getRequest = CreateRequest(HttpMethod.Get, "/shelter", authToken: SHELTER_AUTH);
            var getResult = await client.SendAsync(getRequest);

            Assert.Equal(HttpStatusCode.OK, getResult.StatusCode);

            var returnedData = await getResult.Content.ReadFromJsonAsync<List<Shelter>>();
            var found_shelter = returnedData.Find(sh => sh.HaveSameValues(shelter));
            Assert.NotNull(found_shelter);
        }

        public static IEnumerable<object[]> TestData()
        {
            yield return new object[]
            {
                new Shelter
                {
                    UserName = "TestingShelter",
                    PhoneNumber = "123456789",
                    Email = "shelter@test.petshare",
                    FullShelterName = "Full Testing Shelter Name",
                    IsAuthorized = false,
                    Address = new Address
                    {
                        Street = "Example Avenue",
                        City = "Warsaw",
                        Province = "Mazowieckie",
                        PostalCode = "12-123",
                        Country = "Poland"
                    }
                }
            };
        }

        private HttpRequestMessage CreateRequest(HttpMethod method, string url, string? body = null, string? authToken = null)
        {
            var postRequest = new HttpRequestMessage(method, url);
            if(authToken != null) postRequest.Headers.Add("Authorization", SHELTER_AUTH);
            if(body != null) postRequest.Content = new StringContent(body, Encoding.UTF8, "application/json");

            return postRequest;
        }
    }
}