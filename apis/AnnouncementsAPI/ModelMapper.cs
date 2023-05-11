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
                Status = AnnouncementStatus.Open,
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
