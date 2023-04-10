using AnnouncementsAPI;
using AnnouncementsAPI.Requests;
using AnnouncementsAPI.Responses;
using Microsoft.AspNetCore.WebUtilities;
using System.Net;

namespace APIs_tests.AnnouncementAPTests
{
    public class AnnouncementsBasicTests : APITests<ProgramAnnouncementsAPI, DataContext>
    {
        private const string SHELTER_TOKEN = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI0NzUwYzI4MS00OTg1LTQwY2QtOWFjMC1iM2QzODlhY2YyMDIiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiU2hlbHRlciJdfQ.5XeISfgJqck7GI_C9k20we5s166KrHaZzW4xOdztegs";


        [Fact]
        public async void GetAllAnnouncementsAsShelter()
        {
            var req = CreateRequest(HttpMethod.Get, Urls.Announcements, authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async void GetAllAnnouncementsWithFiltersAsShelter()
        {
            var queryString = new List<KeyValuePair<string, string?>>
            {
                new KeyValuePair<string, string?>("species", "pies"),
                new KeyValuePair<string, string?>("species", "kot"),
                new KeyValuePair<string, string?>("breeds", "golden retriever"),
                new KeyValuePair<string, string?>("breeds", "chihuahua"),
                new KeyValuePair<string, string?>("locations", "Warszawa"),
                new KeyValuePair<string, string?>("locations", "Gdańsk"),
                new KeyValuePair<string, string?>("minAge", "1"),
                new KeyValuePair<string, string?>("maxAge", "5"),
                new KeyValuePair<string, string?>("shelterNames", "Shelter A"),
                new KeyValuePair<string, string?>("shelterNames", "Shelter B")
            };

            var url = QueryHelpers.AddQueryString(Urls.Announcements, queryString);

            var req = CreateRequest(HttpMethod.Get, url, authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async Task<Guid> PostNewPet()
        {
            var postPetRequest = new PostPetRequest()
            {
                Birthday = DateTime.Now,
                Breed = "golden retriever",
                Name = "Czaki",
                Description = "Spokojny, wytresowany futrzak szuka przyjaciela",
                Species = "pies",
            };

            var req = CreateRequest(HttpMethod.Post, Urls.Pets, body: postPetRequest, authToken: SHELTER_TOKEN);
            var res = await SendRequest<PostPetResponse>(req);

            return res.Id;
        }

        [Fact]
        public async Task<Guid> PostNewAnnouncement()
        {
            var petId = await PostNewPet();

            var postAnnouncementReq = new PostAnnouncementRequest()
            {
                Description = "Opis nowego ogłoszenia testowego",
                Title = "Testowe ogłoszenie",
                PetId = petId,
            };

            var req = CreateRequest(HttpMethod.Post, Urls.Announcements, body: postAnnouncementReq, authToken: SHELTER_TOKEN);
            var res = await SendRequest<PostAnnouncementResponse>(req);

            return res.Id;
        }

        [Fact]
        public async void GetAnnouncementById()
        {
            var announcementId = await PostNewAnnouncement();
            var req = CreateRequest(HttpMethod.Get, $"{Urls.Announcements}/{announcementId}", authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async void GetPetById()
        {
            var petId = await PostNewPet();

            var req = CreateRequest(HttpMethod.Get, $"{Urls.Pets}/{petId}", authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);
            
            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async void GetPetsAsShelter()
        {
            var req = CreateRequest(HttpMethod.Get, Urls.Pets, authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async void PutPet()
        {
            var petId = await PostNewPet();

            var putPetRequest = new PutPetRequest()
            {
                Birthday = DateTime.Now,
                Breed = "chihuahua",
                Name = "Kaki",
                Description = "Dobry futrzak",
                Species = "pies",
            };

            var req = CreateRequest(HttpMethod.Get, $"{Urls.Pets}/{petId}", body: putPetRequest, authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async void PutAnnouncement()
        {
            var announcementId = await PostNewAnnouncement();

            var putAnnouncementRequest = new PutAnnouncementRequest()
            {
                Description = "Opis nowego ogłoszenia testowego",
                Title = "Testowe ogłoszenie",
                Status = DatabaseContextLibrary.models.AnnouncementStatus.Closed,
            };

            var req = CreateRequest(HttpMethod.Get, $"{Urls.Announcements}/{announcementId}", body: putAnnouncementRequest, authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }
    }
}
