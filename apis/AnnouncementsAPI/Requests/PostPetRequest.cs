
namespace AnnouncementsAPI.Requests
{
    public class PostPetRequest
    {
        public string Name { get; set; }
        public string Species { get; set; }
        public string Breed { get; set; }
        public DateTime Birthday { get; set; }
        public string Description { get; set; }
    }
}
