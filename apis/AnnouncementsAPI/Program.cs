
using AnnouncementsAPI;
using AnnouncementsAPI.Requests;
using ClaimsManagementLibrary;
using Microsoft.AspNetCore.Authentication.JwtBearer;
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

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "AnnouncementsAPI",
        Version = "v1"
    });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 1safsfsdfdfd\"",
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement {
        {
            new OpenApiSecurityScheme {
                Reference = new OpenApiReference {
                    Type = ReferenceType.SecurityScheme,
                        Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
     .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, c =>
     {
#warning tym zakomentowanym bêdziemy siê przejmowaæ po zrobieniu Auth0
         //c.Authority = $"https://{builder.Configuration["Auth0:Domain"]}";
         c.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
         {
             ValidateAudience = false,
             ValidateIssuer = false,
             IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Auth0:Secret"]!)),
             //ValidAudience = builder.Configuration["Auth0:Audience"],
             //ValidIssuer = $"{builder.Configuration["Auth0:Domain"]}"
         };
     });

builder.Services.AddAuthorization(o =>
{
    o.AddPolicy("Shelter", p => p.
        RequireAuthenticatedUser().
        RequireRole("Shelter"));
    o.AddPolicy("ShelterOrAdmin", p => p.
        RequireAuthenticatedUser().
        RequireRole("Shelter", "Admin"));
});

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
});

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
}).RequireAuthorization("Shelter");

app.MapGet("/announcements/{announcementId}", async (DataContext context, Guid announcementId) =>
{
    var announcement = await context.Announcements.Include("Pet").FirstOrDefaultAsync(a => a.Id == announcementId);

    if (announcement is null)
        return Results.NotFound("Announcement doesn't exist.");

    return Results.Ok(announcement);
});

app.MapPut("/announcements/{announcementId}", async (DataContext context, PutAnnouncementRequest announcementRequest, Guid announcementId, HttpContext httpContext) =>
{
    var announcement = await context.Announcements.FirstOrDefaultAsync(a => a.Id == announcementId);

    if (announcement is null)
        return Results.NotFound("Announcement doesn't exist.");

    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();
    var roleClaim = identity?.GetRole();

    if (identity is null || issuerClaim is null || roleClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    if (announcementRequest.PetId != null)
    {
        var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == announcementRequest.PetId);

        if (pet is null)
            return Results.NotFound("Announcement's pet doesn't exist.");

        if (roleClaim == "Shelter" && pet.ShelterId != shelterId)
            return Results.Unauthorized();
    }

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
}).RequireAuthorization("ShelterOrAdmin");

app.MapGet("/pet", async (DataContext context, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    var pets = await context.Pets.Where(p => p.ShelterId == shelterId).ToListAsync();

    return Results.Ok(pets);
}).RequireAuthorization("Shelter");

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
}).RequireAuthorization("Shelter");

app.MapGet("/pet/{petId}", async (DataContext context, Guid petId) =>
{
    var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
    if (pet is null)
        return Results.NotFound("Pet doesn't exist.");
    return Results.Ok(pet);
});

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
}).RequireAuthorization("ShelterOrAdmin");

app.Run();