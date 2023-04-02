using AnnouncementsAPI.Data;
using AnnouncementsAPI.Requests;
using DatabaseContextLibrary.models;

namespace AnnouncementsAPI
{
    public static class ModelMapper
    {
        public static Announcement Map(this PostAnnouncementRequest announcementRequest)
        {
            return new Announcement()
            {
                Title = announcementRequest.Title,
                Description = announcementRequest.Description,
                CreationDate = DateTime.Now,
                Status = Status.Open,
            };
        }

        public static Pet Map(this NewPet pet)
        {
            return new Pet()
            {
                Name = pet.Name,
                Species = pet.Species,
                Birthday = pet.Birthday,
                Breed = pet.Breed,
                Description = pet.Description,
            };
        }

        public static Pet Map(this PostPetRequest petRequest)
        {
            return new Pet()
            {
                Name = petRequest.Name,
                Birthday = petRequest.Birthday,
                Species = petRequest.Species,
                Breed = petRequest.Breed,
                Description = petRequest.Description,
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
                Description = pet.Description,
                Shelter = pet.Shelter,
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
                Status = announcement.Status
            };
        }
    }
}
