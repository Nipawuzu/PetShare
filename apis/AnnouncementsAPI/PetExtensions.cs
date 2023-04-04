using AnnouncementsAPI.Data;
using DatabaseContextLibrary.models;
using FileStorageLibrary;

namespace AnnouncementsAPI
{
    public static class PetExtensions
    {
        public static async Task UploadPhoto(this Pet pet, byte[]? image, IStorage storage)
        {
            if (image is null) return;

            var photoName = pet.Id.ToString();
            await storage.UploadFileAsync(image, photoName);
        }

        public static string GetPhotoUrl(this Pet pet, IStorage storage)
        {
            return storage.GetDownloadUrl(pet.Id.ToString());
        }

        public static void AttachPhotoUrl(this PetDTO pet, IStorage storage)
        {
            pet.PhotoUrl = storage.GetDownloadUrl(pet.Id.ToString());
        }
    }
}
