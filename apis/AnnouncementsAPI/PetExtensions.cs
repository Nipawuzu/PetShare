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

        public static async Task<string?> GetPhotoUrl(this Pet pet, IStorage storage)
        {
            return await storage.CheckIfExists(pet.Id.ToString()) ? storage.GetDownloadUrl(pet.Id.ToString()) : null;
        }

        public static async Task AttachPhotoUrl(this PetDTO pet, IStorage storage)
        {
            pet.PhotoUrl = await storage.CheckIfExists(pet.Id.ToString()) ? storage.GetDownloadUrl(pet.Id.ToString()) : null;
        }
    }
}
