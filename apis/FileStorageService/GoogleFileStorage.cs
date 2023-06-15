using Google.Apis.Auth.OAuth2;
using Google.Cloud.Storage.V1;
using Microsoft.Extensions.Configuration;
using System.Reflection;
using System.Text;

namespace FileStorageLibrary
{
    public class GoogleFileStorage : IStorage
    {
        private const string _secretKeyName = "GoogleCloud:Secret";
        private const string _bucketKeyName = "GoogleCloud:BucketName";
        private const string _hostUrl = "https://storage.googleapis.com";
        private static readonly string _bucketName;
        private static IConfiguration _config;

        private readonly StorageClient _client;

        static GoogleFileStorage()
        {
            var builder = new ConfigurationBuilder();
            _config = builder.AddUserSecrets(Assembly.GetExecutingAssembly(), true).Build();
            _bucketName = _config[_bucketKeyName]!;
        }

        public GoogleFileStorage()
        {
            var secretJson = GetSecretJson();
            var credentials = GoogleCredential.FromJson(secretJson);
            _client = StorageClient.Create(credentials);
        }

        public async Task UploadFileAsync(Stream stream, string fileName)
        {
            await _client.UploadObjectAsync(_bucketName, fileName, "text/plain", stream);
        }

        public async Task<byte[]?> DownloadFileAsync(string fileName)
        {
            if (!await CheckIfExists(fileName))
                return null;

            using (var stream = new MemoryStream())
            {
                await _client.DownloadObjectAsync(_bucketName, fileName, stream);
                return stream.ToArray();

            }
        }

        public async Task DeleteFileAsync(string fileName)
        {
            if (await CheckIfExists(fileName))
            {
                await _client.DeleteObjectAsync(_bucketName, fileName);
            }
        }

        public async Task<bool> CheckIfExists(string fileName)
        {
            var objects = _client.ListObjectsAsync(_bucketName, Path.GetDirectoryName(fileName));

            await foreach (var item in objects)
            {
                if (item.Name == fileName)
                    return true;
            }

            return false;
        }

        string IStorage.GetDownloadUrl(string filename)
        {
            return GetDownloadUrl(filename);
        }

        public static string GetDownloadUrl(string filename)
        {
            return $"{_hostUrl}/{_bucketName}/{filename}";
        }

        private static string GetSecretJson()
        {
            var sb = new StringBuilder();
            sb.AppendLine("{");
            sb.AppendLine($"\t\"type\": \"{_config[$"{_secretKeyName}:type"]}\",");
            sb.AppendLine($"\t\"project_id\": \"{_config[$"{_secretKeyName}:project_id"]}\",");
            sb.AppendLine($"\t\"private_key_id\": \"{_config[$"{_secretKeyName}:private_key_id"]}\",");
            sb.AppendLine($"\t\"private_key\": \"{_config[$"{_secretKeyName}:private_key"]}\",");
            sb.AppendLine($"\t\"client_email\": \"{_config[$"{_secretKeyName}:client_email"]}\",");
            sb.AppendLine($"\t\"client_id\": \"{_config[$"{_secretKeyName}:client_id"]}\",");
            sb.AppendLine($"\t\"auth_uri\": \"{_config[$"{_secretKeyName}:auth_uri"]}\",");
            sb.AppendLine($"\t\"token_uri\": \"{_config[$"{_secretKeyName}:token_uri"]}\",");
            sb.AppendLine($"\t\"auth_provider_x509_cert_url\": \"{_config[$"{_secretKeyName}:auth_provider_x509_cert_url"]}\",");
            sb.AppendLine($"\t\"client_x509_cert_url\": \"{_config[$"{_secretKeyName}:client_x509_cert_url"]}\"");
            sb.AppendLine("}");
            return sb.ToString();
        }
    }
}