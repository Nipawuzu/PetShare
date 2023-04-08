using DatabaseContextLibrary.models;
using ShelterAPI.Data;
using ShelterAPI.Requests;
using System.Data.Common;

namespace ShelterAPI
{
    public static class ModelMapper
    {
        public static Shelter Map(this PostShelterRequest shelterRequest)
        {
            return new Shelter()
            {
                UserName = shelterRequest.UserName,
                PhoneNumber = shelterRequest.PhoneNumber,
                Email = shelterRequest.Email,
                FullShelterName = shelterRequest.FullShelterName
            };
        }

        public static Address Map(this NewAddress newAddress)
        {
            return new Address()
            {
                Street = newAddress.Street,
                City = newAddress.City,
                PostalCode = newAddress.PostalCode,
                Province = newAddress.Province,
                Country = newAddress.Country
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

        public static ShelterDTO MapDTO(this Shelter shelter)
        {
            return new ShelterDTO()
            {
                UserName = shelter.UserName,
                PhoneNumber = shelter.PhoneNumber,
                Email = shelter.Email,
                FullShelterName = shelter.FullShelterName,
                Id = shelter.Id,
                Address = shelter.Address.MapDTO(),
                IsAuthorized = shelter.IsAuthorized
            };
        }
    }
}
