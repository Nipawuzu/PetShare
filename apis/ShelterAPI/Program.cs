using APIAuthCommonLibrary;
using DatabaseContextLibrary;
using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using ShelterAPI;

const string ConnectionString = "Server=tcp:petshareserver.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity();

builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

builder.Services.AddCustomAuthentication(builder.Configuration["Auth0:Secret"]!);
builder.Services.AddCustomAuthorization();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/shelter", async (DataContext context) =>
    Results.Ok(await context.Shelters.Include("Address").ToListAsync()))
    .RequireAuthorization("Auth");

app.MapGet("/shelter/{shelterId}", async (DataContext context, Guid shelterId) =>
    await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId) is Shelter shelter ?
        Results.Ok(shelter) :
        Results.BadRequest("Sorry, shelter not found"))
    .RequireAuthorization("Auth");

app.MapPost("/shelter", async (DataContext context, Shelter shelter) =>
{
    shelter.Id = Guid.NewGuid();
    shelter.Address.Id = Guid.NewGuid();
    context.Shelters.Add(shelter);
    await context.SaveChangesAsync();
    return Results.Ok();
}).RequireAuthorization("Auth");

app.MapPut("/shelter/{shelterId}", async (DataContext context, Guid shelterId, Shelter updatedShelter) =>
{
    var shelter = await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId);
    if (shelter is null)
        return Results.NotFound("Sorry, this shelter doesn't exist.");

    shelter.IsAuthorized = updatedShelter.IsAuthorized;
    shelter.PhoneNumber = updatedShelter.PhoneNumber;
    shelter.Email = updatedShelter.Email;
    shelter.FullShelterName = updatedShelter.FullShelterName;
    shelter.UserName = updatedShelter.UserName;

    shelter.Address.Country = updatedShelter.Address.Country;
    shelter.Address.City = updatedShelter.Address.City;
    shelter.Address.PostalCode = updatedShelter.Address.PostalCode;
    shelter.Address.Street = updatedShelter.Address.Street;
    shelter.Address.Province = updatedShelter.Address.Province;

    await context.SaveChangesAsync();

    return Results.Ok(await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId));
}).RequireAuthorization("Admin");

app.Run();
