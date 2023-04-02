using FileStorageLibrary;
using System.Text;
using Xunit.Extensions.Ordering;

namespace ImageStorageTests
{
    public class GoogleStorageSimpleTests
    {
        private string testingFileName = "imageStorageTestFile";
        private string testingFileContent = "Hello, world!";

        private readonly IStorage _storage;

        public GoogleStorageSimpleTests()
        {
            _storage = new GoogleFileStorage();
        }

        [Fact, Order(10)]
        public async void UploadSingleFile()
        {
            var content = Encoding.UTF8.GetBytes(testingFileContent);
            await _storage.UploadFileAsync(content, testingFileName);
        }

        [Fact, Order(20)]
        public async void CheckIfExists()
        {
            var res = await _storage.CheckIfExists(testingFileName);
            Assert.True(res);
        }

        [Fact, Order(30)]
        public async void DownloadSingleFile()
        {
            var content = await _storage.DownloadFileAsync(testingFileName);
            Assert.NotNull(content);
            Assert.Equal(testingFileContent, Encoding.UTF8.GetString(content));
        }

        [Fact, Order(40)]
        public void GetDownloadUrlAndDownloadFile()
        {
            var url = _storage.GetDownloadUrl(testingFileName);
            Assert.NotNull(url);

            using (var client = new HttpClient())
            using (var s = client.GetStreamAsync(url))
            using (var fs = new MemoryStream())
            {
                s.Result.CopyTo(fs);
                var bytes = fs.ToArray();
                Assert.NotEmpty(bytes);
            }
        }

        [Fact, Order(100)]
        public async void DeleteSingleFile()
        {
            await _storage.DeleteFileAsync(testingFileName);
        }
    }
}