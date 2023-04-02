
using AnnouncementsAPI;
using AnnouncementsAPI.Requests;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Security.Claims;
using System.Text;

const string ConnectionString = "Server=tcp:petshareserver.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity("AnnouncementsAPI", "v1");

builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

builder.Services.AddCustomAuthentication(builder.Configuration["Auth0:Secret"]!);

builder.Services.AddCustomAuthorization();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/announcements", async (DataContext context, string[]? species, string[]? breeds, string[]? locations, int? minAge, int? maxAge, string[]? shelterNames) =>
{
    var announcements = context.Announcements.Include("Pet").AsQueryable();

    if (species != null && species.Any())
        announcements = announcements.Where(a => species.Contains(a.Pet.Species));

    if (breeds != null && breeds.Any())
        announcements = announcements.Where(a => breeds.Contains(a.Pet.Breed));

    if (locations != null && locations.Any())
        announcements = announcements.Where(a => locations.Contains(a.Pet.Shelter.Address.City));

    announcements = announcements.Where(
        a => (minAge == null || a.Pet.Birthday <= DateTime.Now.AddDays(-(double)minAge))
            && (maxAge == null || a.Pet.Birthday >= DateTime.Now.AddDays(-(double)maxAge)));

    if (shelterNames != null && shelterNames.Any())
        announcements = announcements.Where(a => shelterNames.Contains(a.Pet.Shelter.FullShelterName));

    return await announcements.ToListAsync();
})
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets all announcements filtered with query parameters")
.Produces(200)
.Produces(401);

app.MapPost("/announcements", async (DataContext context, PostAnnouncementRequest announcement, HttpContext httpContext) =>
{
    var newAnnouncement = announcement.Map();


    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    if (announcement.PetId.HasValue)
    {
        var pet = await context.Pets.FindAsync(announcement.PetId);
        if (pet == null)
            return Results.BadRequest("Announcement's pet doesn't exist");

        if (pet.ShelterId != shelterId)
            return Results.Unauthorized();

        newAnnouncement.PetId = announcement.PetId.Value;
    }
    else if (announcement.Pet != null)
    {
        var pet = announcement.Pet.Map();
        pet.ShelterId = shelterId;
        context.Pets.Add(pet);
        await context.SaveChangesAsync();
        newAnnouncement.PetId = pet.Id;
    }

    context.Announcements.Add(newAnnouncement);
    await context.SaveChangesAsync();
    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Post new announcement. Shelter role required. Gets shelterId of pet from auth claims.")
.Produces(200)
.Produces(400)
.Produces(401);

app.MapGet("/announcements/{announcementId}", async (DataContext context, Guid announcementId) =>
{
    var announcement = await context.Announcements.Include("Pet").FirstOrDefaultAsync(a => a.Id == announcementId);

    if (announcement is null)
        return Results.NotFound("Announcement doesn't exist.");

    return Results.Ok(announcement);
})
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets announcement by id.")
.Produces(200)
.Produces(404)
.Produces(401);

app.MapPut("/announcements/{announcementId}", async (DataContext context, PutAnnouncementRequest announcementRequest, Guid announcementId, HttpContext httpContext) =>
{
    var announcement = await context.Announcements.Include("Pet").FirstOrDefaultAsync(a => a.Id == announcementId);

    if (announcement is null)
        return Results.NotFound("Announcement doesn't exist.");

    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();
    var roleClaim = identity?.GetRole();

    if (identity is null || issuerClaim is null || roleClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    Pet announcementPet;
    if (announcementRequest.PetId != null)
    {
        announcementPet = await context.Pets.FirstOrDefaultAsync(p => p.Id == announcementRequest.PetId);

        if (announcementPet is null)
            return Results.BadRequest("Announcement's pet doesn't exist.");
    }
    else
        announcementPet = announcement.Pet;


    if (roleClaim == "Shelter" && announcementPet.ShelterId != shelterId)
        return Results.Unauthorized();

    if (announcementRequest.Title != null)
        announcement.Title = announcementRequest.Title;
    if (announcementRequest.Description != null)
        announcement.Description = announcementRequest.Description;
    if (announcementRequest.Status != null)
        announcement.Status = announcementRequest.Status.Value;
    if (announcementRequest.PetId != null)
        announcement.PetId = announcementRequest.PetId.Value;
    announcement.LastUpdateDate = DateTime.Now;

    await context.SaveChangesAsync();

    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("ShelterOrAdmin")
.WithSummary("Updates announcements. Null values are omitted. Requires admin (any announcement) or shelter (only matching shelterId) role. ")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status400BadRequest)
.Produces(StatusCodes.Status401Unauthorized);

app.MapGet("/pet", async (DataContext context, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    var pets = await context.Pets.Where(p => p.ShelterId == shelterId).ToListAsync();

    return Results.Ok(pets);
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Gets all pets for shelter. Requires shelter role. Gets shelter id from auth claims.")
.Produces(200)
.Produces(401);

app.MapPost("/pet", async (DataContext context, PostPetRequest petRequest, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    var pet = petRequest.Map();
    pet.ShelterId = shelterId;
    context.Pets.Add(pet);
    await context.SaveChangesAsync();
    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Posts new pet. Requires shelter role. Gets shelter id from auth claims.")
.Produces(200)
.Produces(401);

app.MapGet("/pet/{petId}", async (DataContext context, Guid petId) =>
{
    var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
    if (pet is null)
        return Results.NotFound("Pet doesn't exist.");
    return Results.Ok(pet);
})
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets pet by id.")
.Produces(200)
.Produces(404);

app.MapPut("/pet/{petId}", async (DataContext context, PutPetRequest petRequest, Guid petId, HttpContext httpContext) =>
{
    var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
    if (pet is null)
        return Results.NotFound("Pet doesn't exist.");

    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();
    var roleClaim = identity?.GetRole();

    if (identity is null || issuerClaim is null || roleClaim is null)
        return Results.Unauthorized();

    if (roleClaim == "Shelter")
    {
        var shelterId = Guid.Parse(issuerClaim);
        if (pet.ShelterId != shelterId)
            return Results.Unauthorized();
    }

    if (petRequest.Name != null)
        pet.Name = petRequest.Name;
    if (petRequest.Description != null)
        pet.Description = petRequest.Description;
    if (petRequest.Species != null)
        pet.Species = petRequest.Species;
    if (petRequest.Breed != null)
        pet.Breed = petRequest.Breed;
    if (petRequest.Birthday != null)
        pet.Birthday = petRequest.Birthday.Value;
    if (petRequest.Photo != null)
        pet.Photo = petRequest.Photo;

    await context.SaveChangesAsync();

    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("ShelterOrAdmin")
.WithSummary("Updates pet. Null values are omitted. Requires admin (any pet) or shelter (only matching shelterId) role. ")
.Produces(200)
.Produces(404)
.Produces(401);

app.Run();