using APIAuthCommonLibrary;
using CommonDTOLibrary.Models;
using Microsoft.AspNetCore.Http.Json;
using Microsoft.EntityFrameworkCore;
using Reports;
using ReportsAPI;
using ReportsAPI.Responses;
using System.Text.Json.Serialization;

const string ConnectionString = "Server=tcp:petshareserver2.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity("ReportsAPI", "v1");

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

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/reports", Endpoints.GetReports)
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Gets all reports without answer. Requires admin role.")
.Produces(StatusCodes.Status200OK, typeof(GetReportsResponse));

app.MapPost("/reports", Endpoints.AddReport)
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Adds new report.")
.Produces(StatusCodes.Status201Created);

app.MapPut("/reports/{reportId}", Endpoints.UpdateReport)
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Updates status of a report. Requires admin role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status400BadRequest);

app.Run();

// For testing purposes
public partial class ProgramReportsAPI { }
