namespace CommonDTOLibrary.Models
{
    public class PetDTO
    {
        public Guid Id { get; set; }
        public ShelterDTO Shelter { get; set; }
        public string Name { get; set; }
        public string Species { get; set; }
        public string Breed { get; set; }
        public DateTime Birthday { get; set; }
        public string Description { get; set; }
        public string? PhotoUrl { get; set; }
    }
}
