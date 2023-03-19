namespace AnnouncementsAPI.Requests
{
    public class PostAnnouncementRequest
    {
        public string? Title { get; set; }
        public string? Description { get; set; }
        public Guid? PetId { get; set; }
        public NewPet? Pet { get; set; }
    }

    public class NewPet
    {
        public string Name { get; set; }
        public string Species { get; set; }
        public string Breed { get; set; }
        public DateTime Birthday { get; set; }
        public string Description { get; set; }
        public byte[] Photo { get; set; }
    }
}
