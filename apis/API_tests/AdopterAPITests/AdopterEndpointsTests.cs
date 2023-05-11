using AdopterAPI;
using AdopterAPI.Requests;
using CommonDTOLibrary.Models;
using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json.Linq;
using System.Net;

namespace APIs_tests.AdopterAPITests
{
    public class AdopterEndpointsTests : APITests<ProgramAdopterAPI, DataContext>
    {
        [Theory]
        [InlineData(NO_TOKEN, HttpStatusCode.Unauthorized)]
        [InlineData(ADOPTER_TOKEN, HttpStatusCode.Forbidden)]
        [InlineData(SHELTER_TOKEN, HttpStatusCode.Forbidden)]
        [InlineData(ADMIN_TOKEN, HttpStatusCode.OK)]
        public async void OnlyAdminCanGetAdopters(string? token, HttpStatusCode expStatus)
        {
            var getRequest = CreateRequest(HttpMethod.Get, Urls.Adopter, authToken: token);
            var result = await client.SendAsync(getRequest);
            Assert.Equal(expStatus, result.StatusCode);
        }

        [Theory]
        [InlineData(NO_TOKEN, HttpStatusCode.Unauthorized)]
        [InlineData(ADOPTER_TOKEN, HttpStatusCode.Created)]
        [InlineData(SHELTER_TOKEN, HttpStatusCode.Created)]
        [InlineData(ADMIN_TOKEN, HttpStatusCode.Created)]
        public async void CannotPostAdopterWithoutAuth(string? token, HttpStatusCode expStatus)
        {
            var request = GetExamplePostAdopterRequest();
            var postRequest = CreateRequest(HttpMethod.Post, Urls.Adopter, request, token);
            var result = await client.SendAsync(postRequest);
            Assert.Equal(expStatus, result.StatusCode);
        }

        [Theory]
        [MemberData(nameof(PostAdopterDTODataGenerator))]
        public async void TryPostNewAdopter(AdopterDTO adopterDTO)
        {
            var resultID = await PostNewAdopter(adopterDTO);

            var getRequest = CreateRequest(HttpMethod.Get, Urls.Adopter, authToken: ADMIN_TOKEN);
            var adopters = await SendRequest<AdopterDTO[]>(getRequest);

            Assert.NotNull(adopters);
            Assert.NotEmpty(adopters);

            var addedAdopter = adopters.First<AdopterDTO>(x => x.Id == resultID);
            addedAdopter.Should().BeEquivalentTo(adopterDTO, o => o.Excluding(x => x.Id).Excluding(x => x.Status));
        }

        [Theory]
        [MemberData(nameof(PostAdopterDTODataGenerator))]
        public async void NewAdopterIsNotVerified(AdopterDTO adopterDTO)
        {
            var newAdopterID = await PostNewAdopter(adopterDTO);

            var request = CreateRequest(HttpMethod.Get, $"{Urls.Adopter}/{newAdopterID}/isVerified", authToken: SHELTER_TOKEN);
            var response = await SendRequest<bool>(request);

            Assert.False(response);
        }

        [Theory]
        [InlineData(NO_TOKEN, HttpStatusCode.Unauthorized)]
        [InlineData(ADOPTER_TOKEN, HttpStatusCode.Unauthorized)]
        [InlineData(SHELTER_TOKEN, HttpStatusCode.Forbidden)]
        [InlineData(ADMIN_TOKEN, HttpStatusCode.OK)]
        public async void OnlyAdminCanGetAdopterByID(string? token, HttpStatusCode expStatus)
        {
            var newAdopterID = await PostNewAdopter();

            var getAdopterByIdRequest = CreateRequest(HttpMethod.Get, $"{Urls.Adopter}/{newAdopterID}", authToken: token);
            var result = await client.SendAsync(getAdopterByIdRequest);

            Assert.Equal(expStatus, result.StatusCode);
        }

        [Theory]
        [MemberData(nameof(PostAdopterDTODataGenerator))]
        public async void CheckGetAdopterByID(AdopterDTO adopterDTO)
        {
            var newAdopterID = await PostNewAdopter(adopterDTO);

            var getAdopterByIdRequest = CreateRequest(HttpMethod.Get, $"{Urls.Adopter}/{newAdopterID}", authToken: ADMIN_TOKEN);
            var result = await SendRequest<AdopterDTO>(getAdopterByIdRequest);

            result.Should().BeEquivalentTo(adopterDTO, o => o.Excluding(x => x.Id).Excluding(x => x.Status));
        }

        [Theory]
        [InlineData(NO_TOKEN, HttpStatusCode.Unauthorized)]
        [InlineData(ADOPTER_TOKEN, HttpStatusCode.Forbidden)]
        [InlineData(SHELTER_TOKEN, HttpStatusCode.OK)]
        [InlineData(ADMIN_TOKEN, HttpStatusCode.Forbidden)]
        public async void OnlyShelterCanCheckAdopterVerification(string? token, HttpStatusCode expStatus)
        {
            var newAdopterID = await PostNewAdopter();

            var request = CreateRequest(HttpMethod.Get, $"{Urls.Adopter}/{newAdopterID}/isVerified", authToken: token);
            var result = await client.SendAsync(request);

            Assert.Equal(expStatus, result.StatusCode);
        }

        [Theory]
        [InlineData(NO_TOKEN, HttpStatusCode.Unauthorized)]
        [InlineData(ADOPTER_TOKEN, HttpStatusCode.Forbidden)]
        [InlineData(SHELTER_TOKEN, HttpStatusCode.OK)]
        [InlineData(ADMIN_TOKEN, HttpStatusCode.Forbidden)]
        public async void OnlyShelterCanVerifyAdopter(string? token, HttpStatusCode expStatus)
        {
            var newAdopterID = await PostNewAdopter();

            var request = CreateRequest(HttpMethod.Put, $"{Urls.Adopter}/{newAdopterID}/verify", authToken: token);
            var result = await client.SendAsync(request);

            Assert.Equal(expStatus, result.StatusCode);
        }

        [Theory]
        [MemberData(nameof(PostAdopterDTODataGenerator))]
        public async void CheckVerificationWorkflow(AdopterDTO adopterDTO)
        {
            var newAdopterID = await PostNewAdopter(adopterDTO);

            var request = CreateRequest(HttpMethod.Get, $"{Urls.Adopter}/{newAdopterID}/isVerified", authToken: SHELTER_TOKEN);
            var response = await SendRequest<bool>(request);
            Assert.False(response);

            request = CreateRequest(HttpMethod.Put, $"{Urls.Adopter}/{newAdopterID}/verify", authToken: SHELTER_TOKEN);
            var result = await client.SendAsync(request);

            Assert.Equal(HttpStatusCode.OK, result.StatusCode);

            request = CreateRequest(HttpMethod.Get, $"{Urls.Adopter}/{newAdopterID}/isVerified", authToken: SHELTER_TOKEN);
            response = await SendRequest<bool>(request);
            Assert.True(response);
        }

        public static IEnumerable<object[]> PostAdopterDTODataGenerator()
        {
            yield return new object[]
            {
                new AdopterDTO
                {
                    UserName = "Gordon",
                    Email = "gordon@emial.com",
                    PhoneNumber = "1234567890",
                    Status = AdopterStatusDTO.Active,
                    Address = new AddressDTO
                    {
                        Street = "Sezamkowa",
                        City = "Skaryszew",
                        Province = "Mazowieckie",
                        Country = "Poland",
                        PostalCode = "26-640",
                    }
                }
            };
        }

        private async Task<Guid> PostNewAdopter(AdopterDTO? adopter = null)
        {
            PostAdopterRequest adopterRequest;

            if (adopter != null)
                adopterRequest = ToAdopterRequest(adopter);
            else
                adopterRequest = GetExamplePostAdopterRequest();

            var postRequest = CreateRequest(HttpMethod.Post, Urls.Adopter, adopterRequest, ADMIN_TOKEN);
            return await PostRequest(postRequest);
        }

        private static PostAdopterRequest GetExamplePostAdopterRequest()
        {
            return ToAdopterRequest((AdopterDTO)PostAdopterDTODataGenerator().First().First());
        }

        private static PostAdopterRequest ToAdopterRequest(AdopterDTO adopterDTO)
        {
            return new PostAdopterRequest
            {
                UserName = adopterDTO.UserName,
                Email = adopterDTO.Email,
                PhoneNumber = adopterDTO.PhoneNumber,
                Address = adopterDTO.Address,
            };
        }
    }
}
