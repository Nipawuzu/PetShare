using APIAuthCommonLibrary;
using CommonDTOLibrary.Models;
using Microsoft.AspNetCore.Http.Json;
using Microsoft.EntityFrameworkCore;
using ShelterAPI;
using System.Text.Json.Serialization;

const string ConnectionString = "Server=tcp:petshareserver2.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity("ShelterAPI", "v1");
builder.Services.Configure<JsonOptions>(options =>
{
    options.SerializerOptions.Converters.Add(new JsonStringEnumConverter());
});
builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

builder.Services.AddCustomAuthentication(builder.Configuration["Auth0:Audience"]!, builder.Configuration["Auth0:Authority"]!, builder.Configuration["Auth0:Secret"]!);
builder.Services.AddCustomAuthorization();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/shelter", Endpoints.GetShelters)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets all shelters.")
.Produces(StatusCodes.Status200OK, typeof(ShelterDTO[]));

app.MapGet("/shelter/{shelterId}", Endpoints.GetShelter)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets shelter by id.")
.Produces(StatusCodes.Status200OK, typeof(ShelterDTO))
.Produces(StatusCodes.Status404NotFound);

app.MapPost("/shelter", Endpoints.PostShelter)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Posts new shelter.")
.Produces(StatusCodes.Status200OK);

app.MapPut("/shelter/{shelterId}", Endpoints.PutShelter)
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Updates shelter. Requires admin role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status400BadRequest);

app.Run();

// For testing purposes
public partial class ProgramShelterAPI { }
