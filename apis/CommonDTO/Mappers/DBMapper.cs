using CommonDTOLibrary.Models;
using DatabaseContextLibrary.models;

namespace CommonDTOLibrary.Mappers
{
    public static class DBMapper
    {
        public static AdopterDTO MapDTO(this Adopter adopter)
        {
            return new AdopterDTO()
            {
                Address = adopter.Address?.MapDTO(),
                Email = adopter.Email,
                Id = adopter.Id,
                PhoneNumber = adopter.PhoneNumber,
                Status = adopter.Status.MapDTO<AdopterStatusDTO>(),
                UserName = adopter.UserName
            };
        }

        public static ApplicationDTO MapDTO(this Application application)
        {
            return new ApplicationDTO()
            {
                Announcement = application.Announcement?.MapDTO(),
                Adopter = application.Adopter?.MapDTO(),
                AnnouncementId = application.AnnouncementId,
                CreationDate = application.CreationDate,
                ApplicationStatus = application.ApplicationStatus.MapDTO<ApplicationStatusDTO>(),
                Id = application.Id,
                LastUpdateDate = application.LastUpdateDate
            };
        }

        public static PetDTO MapDTO(this Pet pet)
        {
            return new PetDTO()
            {
                Id = pet.Id,
                Name = pet.Name,
                Species = pet.Species,
                Birthday = pet.Birthday,
                Breed = pet.Breed,
                Sex = pet.Sex,
                Description = pet.Description,
                Shelter = pet.Shelter.MapDTO(),
            };
        }

        public static AnnouncementDTO MapDTO(this Announcement announcement)
        {
            return new AnnouncementDTO()
            {
                Title = announcement.Title,
                Description = announcement.Description,
                ClosingDate = announcement.ClosingDate,
                CreationDate = announcement.CreationDate,
                Id = announcement.Id,
                LastUpdateDate = announcement.LastUpdateDate,
                Pet = announcement.Pet.MapDTO(),
                Status = announcement.Status.MapDTO<AnnouncementStatusDTO>()
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

        public static IEnumerable<ApplicationDTO> MapDTO(this IEnumerable<Application> applications)
        {
            foreach (var adopter in applications)
                yield return adopter.MapDTO();
        }

        public static EnumType MapDTO<EnumType>(this Enum enumValue) where EnumType : struct, IConvertible
        {
            if (!Enum.TryParse<EnumType>(enumValue.ToString(), true, out var mappedEnum)
                || !(mappedEnum is EnumType ret))
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
