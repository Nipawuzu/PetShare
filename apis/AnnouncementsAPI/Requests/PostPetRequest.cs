
using DatabaseContextLibrary.models;

namespace AnnouncementsAPI.Requests
{
    public class PostPetRequest
    {
        public string Name { get; set; }
        public string Species { get; set; }
        public string Breed { get; set; }
        public Sex Sex { get; set; }
        public DateTime Birthday { get; set; }
        public string Description { get; set; }
        public string PhotoUrl { get; set; }
    }
}
