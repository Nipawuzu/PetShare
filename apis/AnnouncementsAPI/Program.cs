
using DatabaseContextLibrary;
using Microsoft.EntityFrameworkCore;

const string ConnectionString = "Server=tcp:petshareserver.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/announcements", () =>
{
    throw new NotImplementedException();
});

app.MapPost("/announcements", () =>
{
    throw new NotImplementedException();
});

app.MapGet("/announcements/{announcementId}", (int announcementId) =>
{
    throw new NotImplementedException();
});

app.MapPut("/announcements/{announcementId}", (int announcementId) =>
{
    throw new NotImplementedException();
});

app.Run();