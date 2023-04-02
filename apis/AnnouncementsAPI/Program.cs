using AnnouncementsAPI;
using AnnouncementsAPI.Endpoints;
using APIAuthCommonLibrary;
using FileStorageLibrary;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity("AnnouncementsAPI", "v1");

builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(builder.Configuration.GetConnectionString("DataBase")));

builder.Services.AddCustomAuthentication(builder.Configuration["Auth0:Secret"]!);

builder.Services.AddCustomAuthorization();

builder.Services.AddSingleton<IStorage, GoogleFileStorage>();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/announcements", AnnouncementsEndpoints.GetWithFilters)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets all announcements filtered with query parameters")
.Produces(200)
.Produces(401);

app.MapGet("/announcements/{announcementId}", AnnouncementsEndpoints.GetById)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets announcement by id.")
.Produces(200)
.Produces(404)
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

app.MapGet("/pet", PetEndpoints.GetAllForAuthorisedShelter)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Gets all pets for shelter. Requires shelter role. Gets shelter id from auth claims.")
.Produces(200)
.Produces(401);

app.MapGet("/pet/{petId}", PetEndpoints.GetById)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets pet by id.")
.Produces(200)
.Produces(404);

app.MapPost("/pet", PetEndpoints.Post)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Posts new pet. Requires shelter role. Gets shelter id from auth claims.")
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