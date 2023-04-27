using AdopterAPI.Requests;
using AdopterAPI.Data;
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
                AnnouncementId = applicationRequest.AnnouncementId.GetValueOrDefault(),
                CreationDate = DateTime.Now,
                ApplicationStatus = ApplicationStatus.Created,
                LastUpdateDate = DateTime.Now
            };
        }

        public static AdopterDTO MapDTO(this Adopter adopter)
        {
            return new AdopterDTO()
            {
                Id = adopter.Id,
                UserName = adopter.UserName,
                PhoneNumber = adopter.PhoneNumber,
                Email = adopter.Email,
                Address = adopter.Address?.MapDTO(),
                Status = adopter.Status.MapDTO()
            };
        }

        public static AddressDTO MapDTO(this Address address)
        {
            return new AddressDTO()
            {
                Street = address.Street,
                City = address.City,
                PostalCode = address.PostalCode,
                Province = address.Province,
                Country = address.Country
            };
        }

        public static AdopterStatusDTO MapDTO(this AdopterStatus adopterStatus)
        {
            if (!Enum.TryParse(typeof(AdopterStatusDTO), adopterStatus.ToString(), true, out var adopterStatusDTO)
                || !(adopterStatusDTO is AdopterStatusDTO ret))
                throw new InvalidCastException();

            return ret;
        }

        public static IEnumerable<AdopterDTO> MapDTO(this IEnumerable<Adopter> adopters)
        {
            foreach (var adopter in adopters)
                yield return adopter.MapDTO();
        }
    }
}
