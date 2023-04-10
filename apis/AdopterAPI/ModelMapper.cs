using AdoptersAPI.Requests;
using DatabaseContextLibrary.models;

namespace AdoptersAPI
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
                Address = adopterRequest.Address?.Map(),
                Status = AdopterStatus.Active
            };
        }

        public static Address Map(this NewAddress newAddress)
        {
            return new Address()
            {
                City = newAddress.City,
                Country = newAddress.Country,
                PostalCode = newAddress.PostalCode,
                Province = newAddress.Province,
                Street = newAddress.Street
            };
        }

        public static Application Map(this PostApplicationRequest applicationRequest)
        {
            return new Application()
            {
                AdopterId = applicationRequest.AdopterId.GetValueOrDefault(),
                AnnouncementId = applicationRequest.AnnouncementId.GetValueOrDefault(),
                CreationDate = DateTime.Now,
                ApplicationStatus = ApplicationStatus.Created,
                LastUpdateDate = DateTime.Now
            };
        }
    }
}
