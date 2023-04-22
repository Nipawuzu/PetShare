namespace ShelterAPI.Responses
{
    public class PostShelterResponse
    {
        public Guid Id { get; set; }

        public PostShelterResponse(Guid id)
        {
            Id = id;
        }
    }
}
