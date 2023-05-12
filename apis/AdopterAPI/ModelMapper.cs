using AdopterAPI.Requests;
using CommonDTOLibrary.Mappers;
using DatabaseContextLibrary.models;

namespace AdopterAPI
{
    public static class ModelMapper
    {
        public static Adopter Map(this PostAdopterRequest adopterRequest)
        {
            return new Adopter()
            {
                UserName = adopterRequest.UserName,
                PhoneNumber = adopterRequest.PhoneNumber,
                Email = adopterRequest.Email,
                LastUpdateDate = DateTime.Now,
                Address = adopterRequest.Address?.MapDB(),
                Status = AdopterStatus.Active
            };
        }

        public static Application Map(this PostApplicationRequest applicationRequest)
        {
            return new Application()
            {
                AnnouncementId = applicationRequest.AnnouncementId.GetValueOrDefault(),
                CreationDate = DateTime.Now,
                ApplicationStatus = ApplicationStatus.Created,
                LastUpdateDate = DateTime.Now
            };
        }
    }
}
