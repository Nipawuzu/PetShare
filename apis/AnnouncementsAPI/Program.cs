using AnnouncementsAPI;
using AnnouncementsAPI.Endpoints;
using AnnouncementsAPI.Responses;
using APIAuthCommonLibrary;
using CommonDTOLibrary.Models;
using FileStorageLibrary;
using Microsoft.AspNetCore.Http.Json;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

const string ConnectionString = "Server=tcp:petshareserver2.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity("AnnouncementsAPI", "v1");
builder.Services.AddControllersWithViews()
                .AddJsonOptions(options =>
                options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter()));
builder.Services.Configure<JsonOptions>(options =>
{
    options.SerializerOptions.Converters.Add(new JsonStringEnumConverter());
});
builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

builder.Services.AddCustomAuthentication(builder.Configuration["Auth0:Audience"]!, builder.Configuration["Auth0:Authority"]!, builder.Configuration["Auth0:Secret"]!);

builder.Services.AddCustomAuthorization();

builder.Services.AddSingleton<IStorage, GoogleFileStorage>();

var app = builder.Build();

app.UseCors(options => options.AllowAnyMethod().
                               AllowAnyHeader().
                               SetIsOriginAllowed(_ => true).
                               AllowCredentials());

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/announcements", AnnouncementsEndpoints.GetWithFilters)
.WithOpenApi()
.WithSummary("Gets all announcements filtered with query parameters")
.Produces(200, typeof(GetAnnouncementsReponse));

app.MapGet("/announcements/{announcementId}", AnnouncementsEndpoints.GetById)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets announcement by id.")
.Produces(200, typeof(AnnouncementDTO))
.Produces(404)
.Produces(401);

app.MapGet("/shelter/announcements", AnnouncementsEndpoints.GetForAuthorisedShelter)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets all announcements for shelter. Requires shelter role. Gets shelter id from auth claims.")
.Produces(200, typeof(GetAnnouncementsReponse))
.Produces(401);

app.MapPost("/announcements", AnnouncementsEndpoints.Post)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Post new announcement. Shelter role required. Gets shelterId of pet from auth claims.")
.Produces(200)
.Produces(400)
.Produces(401);

app.MapPut("/announcements/{announcementId}", AnnouncementsEndpoints.Put)
.WithOpenApi()
.RequireAuthorization("ShelterOrAdmin")
.WithSummary("Updates announcements. Null values are omitted. Requires admin (any announcement) or shelter (only matching shelterId) role. ")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status400BadRequest)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPut("/announcements/{announcementId}/like", AnnouncementsEndpoints.PutLiked)
.WithOpenApi()
.RequireAuthorization("Adopter")
.WithSummary("Adds or deletes announcement from liked announcements. Requires adopter role. Gets adopter id from auth claims.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status400BadRequest)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status403Forbidden)
.Produces(StatusCodes.Status404NotFound);

app.MapGet("/shelter/pets", PetEndpoints.GetAllForAuthorisedShelter)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Gets all pets for shelter. Requires shelter role. Gets shelter id from auth claims.")
.Produces(200, typeof(GetPetsResponse))
.Produces(401);

app.MapGet("/pet/{petId}", PetEndpoints.GetById)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets pet by id.")
.Produces(200, typeof(PetDTO))
.Produces(404);

app.MapPost("/pet", PetEndpoints.Post)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Posts new pet. Requires shelter role. Gets shelter id from auth claims.")
.Produces(200)
.Produces(401);

app.MapPost("/pet/{petId}/photo", PetEndpoints.UploadPhoto)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Uploads new photo for pet. Requires shelter role. Gets shelter id from auth claims.")
.Produces(200)
.Produces(401);

app.MapPut("/pet/{petId}", PetEndpoints.Put)
.WithOpenApi()
.RequireAuthorization("ShelterOrAdmin")
.WithSummary("Updates pet. Null values are omitted. Requires admin (any pet) or shelter (only matching shelterId) role. ")
.Produces(200)
.Produces(404)
.Produces(401);

app.Run();

public partial class ProgramAnnouncementsAPI { }