using DatabaseContextLibrary;
using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using ShelterAPI;
using ShelterAPI.Requests;

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

app.MapGet("/shelter", async (DataContext context) =>
    Results.Ok(await context.Shelters.Include("Address").ToListAsync()));

app.MapGet("/shelter/{shelterId}", async (DataContext context, Guid shelterId) =>
    await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId) is Shelter shelter ?
        Results.Ok(shelter) :
        Results.BadRequest("Sorry, shelter not found"));

app.MapPost("/shelter", async (DataContext context, PostShelterRequest shelter) =>
{
    var newShelter = shelter.Map();

    if (shelter.Address != null)
    {
        var newAddress = shelter.Address.Map();
        context.Address.Add(newAddress);
        await context.SaveChangesAsync();
        newShelter.AddressId = newAddress.Id;
    }

    context.Shelters.Add(newShelter);
    await context.SaveChangesAsync();
    return Results.Ok();
});

app.MapPut("/shelter/{shelterId}", async (DataContext context, Guid shelterId, PutShelterRequest updatedShelter) =>
{
    var shelter = await context.Shelters.FirstOrDefaultAsync(s => s.Id == shelterId);
    if (shelter is null)
        return Results.NotFound("Sorry, this shelter doesn't exist.");

    shelter.IsAuthorized = updatedShelter.IsAuthorized;
    await context.SaveChangesAsync();

    return Results.Ok(await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId));
});

app.Run();

// For testing purposes
public partial class ProgramShelterAPI { }
