using APIAuthCommonLibrary;
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

builder.Services.AddSwaggerGenWithSecurity("ShelterAPI", "v1");

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
    .WithOpenApi()
    .RequireAuthorization("Auth")
    .WithSummary("Gets all shelters.")
    .Produces(StatusCodes.Status200OK);

app.MapGet("/shelter/{shelterId}", async (DataContext context, Guid shelterId) =>
    await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId) is Shelter shelter ?
        Results.Ok(shelter) :
        Results.NotFound("Sorry, shelter not found"))
    .WithOpenApi()
    .RequireAuthorization("Auth")
    .WithSummary("Gets shelter by id.")
    .Produces(StatusCodes.Status200OK)
    .Produces(StatusCodes.Status404NotFound);

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
})
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Posts new shelter.")
.Produces(StatusCodes.Status200OK);

app.MapPut("/shelter/{shelterId}", async (DataContext context, Guid shelterId, PutShelterRequest updatedShelter) =>
{
    var shelter = await context.Shelters.FirstOrDefaultAsync(s => s.Id == shelterId);
    if (shelter is null)
        return Results.BadRequest("Sorry, this shelter doesn't exist.");

    shelter.IsAuthorized = updatedShelter.IsAuthorized;
    await context.SaveChangesAsync();

    return Results.Ok(await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId));
})
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Updates shelter. Requires admin role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status400BadRequest);

app.Run();
