using AnnouncementsAPI;
using AnnouncementsAPI.Requests;
using Microsoft.AspNetCore.WebUtilities;
using System.Net;
using System.Text.Json;

namespace APIs_tests.AnnouncementAPTests
{
    public class AnnouncementsAPIBasicTests : APITests<ProgramAnnouncementsAPI, DataContext>
    {
        private const string SHELTER_TOKEN = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI0NzUwYzI4MS00OTg1LTQwY2QtOWFjMC1iM2QzODlhY2YyMDIiLCJleHAiOjE5MTYyMzkwMjIsImF1ZCI6WyJBQUEiXSwicm9sZXMiOlsiU2hlbHRlciJdfQ.5XeISfgJqck7GI_C9k20we5s166KrHaZzW4xOdztegs";
        private const string ANNOUNCEMENTS_URL = "/announcements";

        [Fact]
        public async void GetAllAnnouncementsAsShelter()
        {
            var req = CreateRequest(HttpMethod.Get, ANNOUNCEMENTS_URL, authToken: SHELTER_TOKEN);
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

            var url = QueryHelpers.AddQueryString(ANNOUNCEMENTS_URL, queryString);

            var req = CreateRequest(HttpMethod.Get, url, authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async void PostNewAnnouncementWithPet()
        {
            var postAnnouncementReq = new PostAnnouncementRequest() 
            { 
                Description = "Opis nowego ogłoszenia testowego", 
                Title = "Testowe ogłoszenie",
                Pet = new NewPet()
                {
                    Birthday = DateTime.Now,
                    Breed = "golden retriever", 
                    Name = "Czaki", 
                    Description = "Spokojny, wytresowany futrzak szuka przyjaciela",
                    Species = "pies"
                }
            };

            var req = CreateRequest(HttpMethod.Post, ANNOUNCEMENTS_URL, body: JsonSerializer.Serialize(postAnnouncementReq), authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }
    }
}
