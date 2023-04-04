
namespace FileStorageLibrary
{
    public interface IStorage
    {
        Task UploadFileAsync(byte[] image, string fileName);
        Task<byte[]?> DownloadFileAsync(string fileName);
        Task DeleteFileAsync(string fileName);
        Task<bool> CheckIfExists(string fileName);
        string GetDownloadUrl(string filename);
    }
}
