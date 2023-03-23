using System;
using DatabaseContextLibrary;
using DatabaseContextLibrary.models;
using ShelterAPI.Requests;

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
    }
}
