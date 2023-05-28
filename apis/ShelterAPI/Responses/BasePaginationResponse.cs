namespace ShelterAPI.Responses
{
    public abstract class BasePaginationResponse
    {
        public int PageNumber { get; set; }
        public int Count { get; set; }
    }
}
