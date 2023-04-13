using FluentAssertions;
using ShelterAPI;
using ShelterAPI.Data;
using ShelterAPI.Requests;
using ShelterAPI.Responses;
using System.Net;

namespace APIs_tests.ShelterAPITests
{
    public class SchelterAPIBasicTests : APITests<ProgramShelterAPI, DataContext>
    {
        private const string SHELTER_TOKEN = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJkMDc5NmI4NS04MjYzLTQwYzMtZGQ1NC0wOGRiM2MxNWYxMDgiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiU2hlbHRlciJdfQ.isOtJ-x-QWUTmbDLlauAbIMOON46sGGOAXMGQK5tzH8";
        private const string ADMIN_TOKEN = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIzZmE4NWY2NC01NzE3LTQ1NjItYjNmYy0yYzk2M2Y2NmFmYTYiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiQWRtaW4iXX0.1SnWaA5brkWD2l4yG3ZWczqfvH07tTHWQs9Bmn70q4Q";

        [Theory]
        [MemberData(nameof(ShelterDataGenerator))]
        public async Task<Guid> PostNewShelter(ShelterDTO shelter)
        {
            var postShelterRequest = new PostShelterRequest()
            {
                Address = new NewAddress()
                {
                    Street = shelter.Address.Street,
                    Province = shelter.Address.Province,
                    PostalCode = shelter.Address.PostalCode,
                    City = shelter.Address.City,
                    Country = shelter.Address.Country
                },
                UserName = shelter.UserName,
                PhoneNumber = shelter.PhoneNumber,
                Email = shelter.Email,
                FullShelterName = shelter.FullShelterName
            };

            var postRequest = CreateRequest(HttpMethod.Post, Urls.Shelter, postShelterRequest, SHELTER_TOKEN);
            var postResult = await SendRequest<PostShelterResponse>(postRequest);
            return postResult.Id;
        }


        [Theory]
        [MemberData(nameof(ShelterDataGenerator))]
        public async void PostAndGetNewShelter(ShelterDTO shelter)
        {
            var shelterId = await PostNewShelter(shelter);

            var getRequest = CreateRequest(HttpMethod.Get, $"{Urls.Shelter}/{shelterId}", authToken: SHELTER_TOKEN);
            var getResult = await SendRequest<GetShelterResponse>(getRequest);

            getResult.Should().BeEquivalentTo(shelter, o => o.Excluding(x => x.Id).Excluding(x => x.IsAuthorized));
        }

        [Fact]
        public async void GetAllShelters()
        {
            var getRequest = CreateRequest(HttpMethod.Get, Urls.Shelter, authToken: SHELTER_TOKEN);
            await SendRequest<GetSheltersResponse>(getRequest);
        }

        [Theory]
        [MemberData(nameof(ShelterDataGenerator))]
        public async void PutShelter(ShelterDTO shelter)
        {
            var shelterId = await PostNewShelter(shelter);
            var req = new PutShelterRequest() { IsAuthorized = true };

            var getRequest = CreateRequest(HttpMethod.Put, $"{Urls.Shelter}/{shelterId}", req, authToken: ADMIN_TOKEN);
            var res = await this.client.SendAsync(getRequest);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        public static IEnumerable<object[]> ShelterDataGenerator()
        {
            yield return new object[]
            {
                new ShelterDTO
                {
                    UserName = "pazurek",
                    PhoneNumber = "+48123456789",
                    Email = "shelter@test.petshare",
                    FullShelterName = "Schronisko pod kocim pazurem",
                    Address = new AddressDTO
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