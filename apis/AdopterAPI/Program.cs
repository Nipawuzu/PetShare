using AdopterAPI.Endpoints;
using AdopterAPI;
using AdopterAPI.Requests;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Net.Http;
using System.Security.Claims;

const string ConnectionString = "Server=tcp:petshareserver2.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity("AdopterAPI", "v1");

builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

builder.Services.AddCustomAuthentication(builder.Configuration["Auth0:Audience"]!, builder.Configuration["Auth0:Authority"]!, builder.Configuration["Auth0:Secret"]!);
builder.Services.AddCustomAuthorization();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/adopter", AdopterEndpoints.GetAdopters)
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Get all adopters. Requires admin role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapGet("/adopter/{adopterId}", AdopterEndpoints.GetAdopter)
.WithOpenApi()
.RequireAuthorization("AdopterOrAdmin")
.WithSummary("Get adopter by id. Requires admin role (any adopter) or adopter role (only matching id).")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status404NotFound);

app.MapPost("/adopter", AdopterEndpoints.PostAdopter)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Posts new adopter.")
.Produces(StatusCodes.Status201Created)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPut("/adopter/{adopterId}", AdopterEndpoints.PutAdopter)
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Updates adopter. Requires admin role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapGet("/adopter/{adopterId}/isVerified", AdopterEndpoints.GetAdopterVerified)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Gets info if specified adopter is verified by shelter provided in token. Requires shelter role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPut("/adopter/{adopterId}/verify", AdopterEndpoints.PutAdopterVerified)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Verifies adopter for shelter provided in token. Requires shelter role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapGet("/applications", ApplicationsEndpoints.GetApplications)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets all applications. Requires any role. For shelter, applications are filtered only for that shelter. For adopter, applications are filtered only for that adopter. Admin gets them all.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapGet("/applications/{announcementId}", ApplicationsEndpoints.GetApplicationsForAnnouncement)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Gets application for specified announcement. Requires shelter role matching with announcement's shelter.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPost("/applications", ApplicationsEndpoints.PostApplication)
.WithOpenApi()
.RequireAuthorization("Adopter")
.WithSummary("Posts new application. Requires adopter role matching with requested application's adopterId.")
.Produces(StatusCodes.Status201Created)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPut("/applications/{applicationId}/accept", ApplicationsEndpoints.PutApplicationAccept)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Accepts application. Requires shelter role matching with shelterId of application.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapPut("/applications/{applicationId}/reject", ApplicationsEndpoints.PutApplicationReject)
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Rejects application. Requires shelter role matching with shelterId of application.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapPut("/applications/{applicationId}/withdraw", ApplicationsEndpoints.PutApplicationWithdraw)
.WithOpenApi()
.RequireAuthorization("Adopter")
.WithSummary("Withdraws application. Requires adopter role matching with adopterId of application.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.Run();

// For testing purposes
public partial class ProgramAdopterAPI { }
