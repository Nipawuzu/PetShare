using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Net;
using System.Text;
using System.Text.Json;

namespace APIs_tests
{
    public abstract class APITests<API, DataContext> 
        where DataContext : DbContext 
        where API : class
    {
        protected WebApplicationFactory<API> application;
        protected HttpClient client;

        public APITests()
        {
            application = new WebApplicationFactory<API>()
               .WithWebHostBuilder(builder => builder
                   .ConfigureServices(services =>
                   {
                       var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<DataContext>));

                       if (descriptor != null)
                       {
                           services.Remove(descriptor);
                       }

                       services.AddDbContext<DataContext>(opt => opt.UseInMemoryDatabase(this.GetType().Name));
                   }));

            client = application.CreateClient();
            MockServices();
        }

        private void MockServices()
        {
            using (var scope = application.Services.CreateScope())
            {
                var dbContext = scope.ServiceProvider.GetService<DataContext>();
                if(dbContext != null) MockDatabase(dbContext);
            }
        }

        protected virtual void MockDatabase(DataContext context)
        {
        }

        protected HttpRequestMessage CreateRequest(HttpMethod method, string url, object? body = null, string? authToken = null)
        {
            var postRequest = new HttpRequestMessage(method, url);
            if (authToken != null) postRequest.Headers.Add("Authorization", authToken);
            if (body != null)
            {
                var content = JsonSerializer.Serialize(body);
                postRequest.Content = new StringContent(content, Encoding.UTF8, "application/json");
            }
            return postRequest;
        }

        protected async Task<T> SendRequest<T>(HttpRequestMessage request)
        {
            var res = await client.SendAsync(request);

            Assert.Equal(HttpStatusCode.OK, res.StatusCode);
            var content = await res.Content.ReadAsStringAsync();
            var serializationOptions = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            var resObj = JsonSerializer.Deserialize(content, typeof(T), serializationOptions);
            Assert.NotNull(resObj);

            return (T)resObj;
        }

        protected async Task<Guid> PostRequest(HttpRequestMessage request)
        {
            var res = await client.SendAsync(request);

            Assert.Equal(HttpStatusCode.Created, res.StatusCode);
            var resId = res.Headers.Location;
            Assert.NotNull(resId);

            return new Guid(resId.ToString());
        }
    }
}
