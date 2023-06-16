using Google.Apis.Auth.OAuth2;
using Google.Cloud.Storage.V1;
using Microsoft.Extensions.Configuration;
using System.Reflection;
using System.Text;

namespace FileStorageLibrary
{
    public class GoogleFileStorage : IStorage
    {
        private const string _hostUrl = "https://storage.googleapis.com";
        private const string _bucketName = "petshare-6fe6e.appspot.com";
        private const string _type = "service_account";
        private const string _projectId = "petshare-6fe6e";
        private const string _privateKeyId = "b8c85aa524a1464e7c96f6c51ad2ae6cc4172775";
        private const string _privateKey = "-----BEGIN PRIVATE KEY-----\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDfpUlR+32sfouU\\nXgXr4uTvc3wiKLqIrG3w45xkqz5Ur9Xhe7opEQI26jElaZQ+Y48aoj6TYNU/xTbz\\n7I5Knf1lLWGNAXWzV1zauTnXBSaDmJMdj4umjqgWSCo1Pq/F/3d7YIIQwF+WwXo1\\nRl5qFPM9KsLM9af0uYgkr80fa9ATqKYh3b4JYdzdxwuyDS5zujfC7r1wJk57veZF\\nXPdMUoHuiAa3blScMmOMrMA3WYaCGRLcoDL52X5MwZ58f21ZNL806lQ9uMjZoHh0\\nP6MOCFMO+LILTlAjadkbdECD5in4QuOa5hmLeL+6fPwGYLNbn3R8rC9cwJYZemTn\\nPnTcCqNLAgMBAAECggEACOXrImNmryfDxu3sv2NiJ3LJVBSZw1lU8Hol3U2A596t\\nHFEPaZXfKC8uMGZgexD7/xvIcJWwNl7S3mahjK93hwCEupb9x1po+9zVw8vVKfQ2\\nmjz9We2gG27YmxC47qBI8TQ4SJFW3EkrYxY/KGpX+S2L3ZrCiXaeR5NlDmR8PWPr\\n2WqC+1nMirKQm92SoCPMrsZysC5IhpNkmaVIfFgcpBH932NI8G7fkLZXC27L8Mc+\\nkiLTlK1MlI1xTmaBoZq0MaRfjiFj89Iqup4SD7bu2BfOB8pf8yiXeMxssuAN3LNU\\nhSgwVjg5A7SM/hmQW3ZCeemEP7ZmufQ/lqP6e36kaQKBgQDyrRCVLWcw/1Sffyvf\\nWeL3WfRkSKV2ZY+pPnsWRCKSPC00eVAHT0tafR5Atja+F5f3tZCPjastDHF0avsk\\nhl7d2w/zaZVnsAd1X2Wt1zGBKBmlHbOz+WcDjoMK4t6fH8EIa30h50dVdF1Bwvh0\\nTEA7vsl4xLDj3PeZ4n1T/tefgwKBgQDr7L1peWFs79z3FC56YHA7GeHny3bCspYx\\nJL1xJTB6Tn6QU+YDf3uUUX4gSzPUScrzc4DEgiK1A9VCSOhfyVQPKpLWAQ9kYbHl\\nNRLVq8UkXnyp5+s9azKJOklGlZ2uzZcwNXoAfIXsdyhZDU4vJxIPPpkc35HJ3Mod\\njGGWutMamQKBgQDH9pc9dQYct6gRLQcHqdd9nh/lKn89Cf7QpG1kMYyTFwbgwD2T\\naGFdFNAC3qJJDMPqFzAhOckc+63ZEfYTaK1u/f0sw4mawM/EhXERR8rA9Dv9dHYJ\\nDK83nQyZwctTLyUuPPQFJb//yDy33WJA4jvjfxggbWKcwA0+PgSrW8hs5QKBgQCg\\nZy9I3Pv+Yv7rBk+raJIlvK05Ob6fFWjENOSQXuac4W1vl3tVeYF+EAIe1sKAXUOd\\nTjSIZqpORDLkhElphqqePSXkVoguibW3zuPlXooE9jDwG/x2n8GWR4i2ctbomGNo\\npZMzbXZolYNbOI6lxHyk3LyhQugORQ0uFdnr703EUQKBgBaUlcpVHhHKMT1lAf+R\\nTlZ6GvNI2DhDgCKJNVzRPwQtUnlFZKsM3bTGGBsuHl7dfWjXUY54AydMgCHu/hFe\\njLYdLhTaX6O8wyxi62i1gSOoohyWzNF1IFMLxpdIyyP2BfppdVy/RkOTDdhzABEv\\nwjrunCgz0PJgrWa5odkdatxC\\n-----END PRIVATE KEY-----\\n";
        private const string _clientEmail = "petshare-6fe6e@appspot.gserviceaccount.com";
        private const string _clientId = "108041561444475311360";
        private const string _authUri = "https://accounts.google.com/o/oauth2/auth";
        private const string _tokenUri = "https://oauth2.googleapis.com/token";
        private const string _authProviderUrl = "https://www.googleapis.com/oauth2/v1/certs";
        private const string _clientUrl = "https://www.googleapis.com/robot/v1/metadata/x509/petshare-6fe6e%40appspot.gserviceaccount.com";

        private readonly StorageClient _client;

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

        private string GetSecretJson()
        {
            var sb = new StringBuilder();
            sb.AppendLine("{");
            sb.AppendLine($"\t\"type\": \"{_type}\",");
            sb.AppendLine($"\t\"project_id\": \"{_projectId}\",");
            sb.AppendLine($"\t\"private_key_id\": \"{_privateKeyId}\",");
            sb.AppendLine($"\t\"private_key\": \"{_privateKey}\",");
            sb.AppendLine($"\t\"client_email\": \"{_clientEmail}\",");
            sb.AppendLine($"\t\"client_id\": \"{_clientId}\",");
            sb.AppendLine($"\t\"auth_uri\": \"{_authUri}\",");
            sb.AppendLine($"\t\"token_uri\": \"{_tokenUri}\",");
            sb.AppendLine($"\t\"auth_provider_x509_cert_url\": \"{_authProviderUrl}\",");
            sb.AppendLine($"\t\"client_x509_cert_url\": \"{_clientUrl}\"");
            sb.AppendLine("}");
            return sb.ToString();
        }
    }
}