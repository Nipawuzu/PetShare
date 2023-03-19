
using AnnouncementsAPI;
using AnnouncementsAPI.Requests;
using DatabaseContextLibrary;
using DatabaseContextLibrary.models;
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
        a =>   (minAge == null || a.Pet.Birthday <= DateTime.Now.AddDays(-(double)minAge)) 
            && (maxAge == null || a.Pet.Birthday >= DateTime.Now.AddDays(-(double)maxAge)));

    if (shelterNames != null && shelterNames.Any())
        announcements = announcements.Where(a => shelterNames.Contains(a.Pet.Shelter.FullShelterName));

    return await announcements.ToListAsync();
});

app.MapPost("/announcements", async (DataContext context, PostAnnouncementRequest announcement) =>
{

    var newAnnouncement = announcement.Map();
    if (announcement.PetId.HasValue)
    {
        var pet = await context.Pets.FindAsync(announcement.PetId);
        if (pet == null)
            return Results.Problem();

        newAnnouncement.PetId = announcement.PetId.Value;
    }
    else if(announcement.Pet != null)
    {
        var pet = announcement.Pet.Map();
#warning Póki nie ma autoyzacji i claimów
        pet.ShelterId = new Guid("3fa85f64-5717-4562-b3fc-2c963f66afa6");
        context.Pets.Add(pet);
        await context.SaveChangesAsync();
        newAnnouncement.PetId = pet.Id;
    }

    context.Announcements.Add(newAnnouncement);
    await context.SaveChangesAsync();
    return Results.Ok();
});

app.MapGet("/announcements/{announcementId}", async (DataContext context, Guid announcementId) =>
{
    var announcement = await context.Announcements.Include("Pet").FirstOrDefaultAsync(a => a.Id == announcementId);

    if (announcement is null)
        return Results.NotFound("Announcement doesn't exist.");

    return Results.Ok(announcement);
});

app.MapPut("/announcements/{announcementId}", async (DataContext context, Announcement updatedAnnouncement, Guid announcementId) =>
{
    var announcement = await context.Announcements.FirstOrDefaultAsync(a => a.Id == announcementId);

    if (announcement is null)
        return Results.NotFound("Announcement doesn't exist.");

    announcement.Title = updatedAnnouncement.Title;
    announcement.Description = updatedAnnouncement.Description;
    announcement.CreationDate = updatedAnnouncement.CreationDate;
    announcement.ClosingDate = updatedAnnouncement.ClosingDate;
    announcement.LastUpdateDate = updatedAnnouncement.LastUpdateDate;
    announcement.Status = updatedAnnouncement.Status;
    announcement.PetId = updatedAnnouncement.PetId;
    announcement.Pet = updatedAnnouncement.Pet;

    await context.SaveChangesAsync();

    return Results.Ok();
});

app.MapGet("/pet", () =>
{

});

app.MapPost("/pet", async (DataContext context, Pet pet) =>
{
    context.Pets.Add(pet);
    await context.SaveChangesAsync();
    return Results.Ok();
});

app.MapGet("/pet/{petId}", async (DataContext context, Guid petId) =>
{
    var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
    if (pet is null)
        return Results.NotFound("Pet doesn't exist.");
    return Results.Ok(pet);
});

app.MapPut("/pet/{petId}", async (DataContext context, Pet updatedPet, Guid petId) =>
{
    var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
    if (pet is null)
        return Results.NotFound("Pet doesn't exist.");

    pet.Name = updatedPet.Name;
    pet.ShelterId = updatedPet.ShelterId;
    pet.Shelter = updatedPet.Shelter;
    pet.Species = updatedPet.Species;
    pet.Breed = updatedPet.Breed;
    pet.Birthday = updatedPet.Birthday;
    pet.Description = updatedPet.Description;
    pet.Photo = updatedPet.Photo;

    await context.SaveChangesAsync();

    return Results.Ok();
});

app.Run();