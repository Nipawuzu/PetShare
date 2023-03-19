using DatabaseContextLibrary.models;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualStudio.TestPlatform.TestHost;
using ShelterAPI;
using System.Net;
using System.Net.Http.Json;
using System.Reflection;

namespace API_tests
{
    public class SchelterAPI_tests
    {
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
            var result = await client.PostAsJsonAsync("/shelter", shelter);

            Assert.Equal(HttpStatusCode.OK, result.StatusCode);

            var returned_data = await client.GetFromJsonAsync<List<Shelter>>("/shelter");
            Assert.NotNull(returned_data);

            var found_shelter = returned_data.Find(sh => sh.HaveSameValues(shelter));
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
    }
}