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
                Photo = pet.Photo, 
            };
        }
    }
}
