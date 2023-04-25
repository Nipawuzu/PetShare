using CommonDTOLibrary.Models;
using DatabaseContextLibrary.models;

namespace CommonDTOLibrary.Mappers
{
    public static class DTOMapper
    {
        public static Address MapDB(this AddressDTO newAddress)
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
