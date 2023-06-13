using AnnouncementsAPI.Requests;
using AnnouncementsAPI.Responses;
using CommonDTOLibrary.Mappers;
using CommonDTOLibrary.Models;
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
                Status = AnnouncementStatus.Open,
                LastUpdateDate = DateTime.Now
            };
        }

        public static GetAnnouncementsWithFiltersResponse Map(this Announcement announcement)
        {
            return new GetAnnouncementsWithFiltersResponse()
            {
                Title = announcement.Title,
                Description = announcement.Description,
                ClosingDate = announcement.ClosingDate,
                CreationDate = announcement.CreationDate,
                Id = announcement.Id,
                LastUpdateDate = announcement.LastUpdateDate,
                Pet = announcement.Pet.MapDTO(),
                Status = announcement.Status.MapDTO<AnnouncementStatusDTO>(),
                IsLiked = false
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
                Sex = petRequest.Sex,
                Description = petRequest.Description,
            };
        }
    }
}
