
﻿using FluentAssertions;
using Microsoft.Extensions.Configuration;
﻿using CommonDTOLibrary.Models;
using ShelterAPI;
using ShelterAPI.Requests;
using System.Net;
using ShelterAPI.Responses;

namespace APIs_tests.ShelterAPITests
{
    public class SchelterAPIBasicTests : APITests<ProgramShelterAPI, DataContext>
    {
        [Theory]
        [MemberData(nameof(ShelterDataGenerator))]
        public async Task<Guid> PostNewShelter(ShelterDTO shelter)
        {
            var postShelterRequest = new PostShelterRequest()
            {
                Address = new AddressDTO()
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
            var postResult = await PostRequest(postRequest);
            return postResult;
        }


        [Theory]
        [MemberData(nameof(ShelterDataGenerator))]
        public async void PostAndGetNewShelter(ShelterDTO shelter)
        {
            var shelterId = await PostNewShelter(shelter);

            var getRequest = CreateRequest(HttpMethod.Get, $"{Urls.Shelter}/{shelterId}", authToken: SHELTER_TOKEN);
            var getResult = await SendRequest<ShelterDTO>(getRequest);

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