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
    }
}
