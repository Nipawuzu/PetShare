using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Text;

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
        }

        protected HttpRequestMessage CreateRequest(HttpMethod method, string url, string? body = null, string? authToken = null)
        {
            var postRequest = new HttpRequestMessage(method, url);
            if (authToken != null) postRequest.Headers.Add("Authorization", authToken);
            if (body != null) postRequest.Content = new StringContent(body, Encoding.UTF8, "application/json");

            return postRequest;
        }
    }
}
