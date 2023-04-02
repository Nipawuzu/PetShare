using DatabaseContextLibrary.models;

namespace AnnouncementsAPI.Responses
{
    public class GetPetResponse
    {
        public Guid Id { get; set; }
        public Shelter Shelter { get; set; }
        public string Name { get; set; }
        public string Species { get; set; }
        public string Breed { get; set; }
        public DateTime Birthday { get; set; }
        public string Description { get; set; }
        public string? PhotoUrl { get; set; }

        public GetPetResponse(Pet pet, string? photoUrl)
        {
            Id = pet.Id;
            Name = pet.Name;
            Species = pet.Species;
            Birthday = pet.Birthday;
            Breed = pet.Breed;
            Description = pet.Description;
            Shelter = pet.Shelter;
            PhotoUrl = photoUrl;
        }
    }
}
