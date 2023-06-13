using AnnouncementsAPI;
using AnnouncementsAPI.Requests;
using DatabaseContextLibrary.models;
using Microsoft.AspNetCore.WebUtilities;
using System.Net;

namespace APIs_tests.AnnouncementAPITests
{
    public class AnnouncementsBasicTests : APITests<ProgramAnnouncementsAPI, DataContext>
    {
        private const string SHELTER_ID = "d0796b85-8263-40c3-dd54-08db3c15f108";

        [Fact]
        public async void GetAllAnnouncementsAsShelter()
        {
            var req = CreateRequest(HttpMethod.Get, Urls.AnnouncementsForShelter, authToken: SHELTER_TOKEN);
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
                Sex = Sex.Male, 
                PhotoUrl = "",
            };

            var req = CreateRequest(HttpMethod.Post, Urls.Pets, body: postPetRequest, authToken: SHELTER_TOKEN);
            var res = await PostRequest(req);

            return res;
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
            var res = await PostRequest(req);

            return res;
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
            var req = CreateRequest(HttpMethod.Get, Urls.PetsForShelter, authToken: SHELTER_TOKEN);
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
                Status = AnnouncementStatus.Closed,
            };

            var req = CreateRequest(HttpMethod.Put, $"{Urls.Announcements}/{announcementId}", body: putAnnouncementRequest, authToken: SHELTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }


        [Fact]
        public async void LikeAnnouncement()
        {
            var announcementId = await PostNewAnnouncement();

            var queryString = new List<KeyValuePair<string, string?>>
            {
                new KeyValuePair<string, string?>("isLiked", "true"),
            };

            var url = QueryHelpers.AddQueryString($"{Urls.Announcements}/{announcementId}/like", queryString);

            var req = CreateRequest(HttpMethod.Put, url, authToken: ADOPTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        [Fact]
        public async void GetLikedAnnouncements()
        {
            var queryString = new List<KeyValuePair<string, string?>>
            {
                new KeyValuePair<string, string?>("isLiked", "true"),
            };

            var url = QueryHelpers.AddQueryString(Urls.Announcements, queryString);

            var req = CreateRequest(HttpMethod.Get, url, authToken: ADOPTER_TOKEN);
            var res = await client.SendAsync(req);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
        }

        protected override void MockDatabase(DataContext context)
        {
            var foundSheler = context.Shelters.Find(Guid.Parse(SHELTER_ID));
            if (foundSheler != null) return;

            var address = new Address()
            {
                City = "Test city",
                Country = "Test country",
                PostalCode = "00000",
                Province = "Test province",
                Street = "Test street",
            };

            context.Address.Add(address);
            context.SaveChanges();

            var shelter = new Shelter()
            {
                Id = Guid.Parse(SHELTER_ID),
                AddressId = address.Id,
                Email = "test@test.pl",
                FullShelterName = "Test full shelter name",
                PhoneNumber = "000000000",
                UserName = "Test username",
            };

            context.Shelters.Add(shelter);
            context.SaveChanges();
        }
    }
}
