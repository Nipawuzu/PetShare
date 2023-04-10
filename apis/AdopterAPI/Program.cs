using AdoptersAPI;
using AdoptersAPI.Requests;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Net.Http;
using System.Security.Claims;

const string ConnectionString = "Server=tcp:petshareserver.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGenWithSecurity("AdopterAPI", "v1");

builder.Services.AddDbContext<DataContext>(opt => opt.UseSqlServer(ConnectionString));

builder.Services.AddCustomAuthentication(builder.Configuration["Auth0:Secret"]!);
builder.Services.AddCustomAuthorization();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.UseHttpsRedirection();

app.MapGet("/adopter", async (DataContext dbContext) =>
{
    return await dbContext.Adopters.Include("Address").ToListAsync();
})
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Get all adopters. Requires admin role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapGet("/adopter/{adopterId}", async (DataContext dbContext, Guid adopterId, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();
    var roleClaim = identity?.GetRole();

    if (identity is null || issuerClaim is null || roleClaim is null)
        return Results.Unauthorized();

    if (roleClaim == "Adopter")
    {
        var claimAdopterId = Guid.Parse(issuerClaim);
        if(claimAdopterId != adopterId)
            return Results.Unauthorized();
    }


    var adopter = await dbContext.Adopters.Include("Address").FirstOrDefaultAsync(a => a.Id == adopterId);
    if (adopter is null) return Results.NotFound("Adopter doesn't exist.");
    return Results.Ok(adopter);
})
.WithOpenApi()
.RequireAuthorization("AdopterOrAdmin")
.WithSummary("Get adopter by id. Requires admin role (any adopter) or adopter role (only matching id).")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status404NotFound);

app.MapPost("/adopter", async (DataContext dbContext, PostAdopterRequest adopter) =>
{
    var newAdopter = adopter.Map();

    if (adopter.Address != null)
    {
        var newAddress = adopter.Address.Map();
        dbContext.Address.Add(newAddress);
        await dbContext.SaveChangesAsync();
        newAdopter.AddressId = newAddress.Id;
    }

    dbContext.Adopters.Add(newAdopter);
    await dbContext.SaveChangesAsync();
    return Results.Created(newAdopter.Id.ToString(), newAdopter);
})
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Posts new adopter.")
.Produces(StatusCodes.Status201Created)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPut("/adopter/{adopterId}", async (DataContext dbContext, Guid adopterId, PutAdopterRequest updatedAdopter) =>
{
    var adopter = await dbContext.Adopters.Include("Address").FirstOrDefaultAsync(a => a.Id == adopterId);
    if (adopter is null)
        return Results.BadRequest("Adopter doesn't exist.");

    if (adopter.Status != updatedAdopter.Status)
    {
        adopter.Status = updatedAdopter.Status;
        await dbContext.SaveChangesAsync();
    }

    return Results.Ok(adopter);
})
.WithOpenApi()
.RequireAuthorization("Admin")
.WithSummary("Updates adopter. Requires admin role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapGet("/adopter/{adopterId}/isVerified", async (DataContext dbContext, Guid adopterId, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    return Results.Ok(await dbContext.AdopterShelterLinkingTable.AnyAsync(aslt => aslt.AdopterId == adopterId && aslt.ShelterId == shelterId));
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Gets info if specified adopter is verified by shelter provided in token. Requires shelter role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPut("/adopter/{adopterId}/verify", async (DataContext dbContext, Guid adopterId, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    var verified = await dbContext.AdopterShelterLinkingTable.FirstOrDefaultAsync(aslt => aslt.AdopterId == adopterId && aslt.ShelterId == shelterId);

    if (verified != null)
        return Results.BadRequest("Adopter already verified.");

    dbContext.AdopterShelterLinkingTable.Add(new AdopterShelterLinkingTable()
    {
        AdopterId = adopterId,
        ShelterId = shelterId
    });
    await dbContext.SaveChangesAsync();

    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Verifies adopter for shelter provided in token. Requires shelter role.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapGet("/applications", async (DataContext dbContext, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();
    var roleClaim = identity?.GetRole();

    if (identity is null || issuerClaim is null || roleClaim is null)
        return Results.Unauthorized();

    switch (roleClaim)
    {
        case "Shelter":
            var shelterId = Guid.Parse(issuerClaim);
            return Results.Ok(await dbContext.Applications.Include("Announcement").Where(a => a.Announcement!.Pet.ShelterId == shelterId).ToListAsync());
        case "Adopter":
            var adopterId = Guid.Parse(issuerClaim);
            return Results.Ok(await dbContext.Applications.Include("Announcement").Where(a => a.AdopterId == adopterId).ToListAsync());
        case "Admin":
            return Results.Ok(await dbContext.Applications.ToListAsync());
        default:
            return Results.BadRequest();
    }
})
.WithOpenApi()
.RequireAuthorization("Auth")
.WithSummary("Gets all applications. Requires any role. For shelter, applications are filtered only for that shelter. For adopter, applications are filtered only for that adopter. Admin gets them all.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapGet("/applications/{announcementId}", async (DataContext dbContext, Guid announcementId, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    var applications = await dbContext.Applications.Include("Announcement").Where(a => a.AnnouncementId == announcementId).ToListAsync();

    if (applications.Any() && applications.First().Announcement!.Pet.ShelterId != shelterId)
        return Results.Unauthorized();

    return Results.Ok(applications);
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Gets application for specified announcement. Requires shelter role matching with announcement's shelter.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPost("/applications", async (DataContext dbContext, PostApplicationRequest application, HttpContext httpContext) =>
{
    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var adopterId = Guid.Parse(issuerClaim);

    if (adopterId != application.AdopterId)
        return Results.Unauthorized();

    var newApplication = application.Map();

    dbContext.Applications.Add(newApplication);
    await dbContext.SaveChangesAsync();

    return Results.Created(newApplication.Id.ToString(), newApplication);
})
.WithOpenApi()
.RequireAuthorization("Adopter")
.WithSummary("Posts new application. Requires adopter role matching with requested application's adopterId.")
.Produces(StatusCodes.Status201Created)
.Produces(StatusCodes.Status401Unauthorized);

app.MapPut("/applications/{applicationId}/accept", async (DataContext dbContext, Guid applicationId, HttpContext httpContext) =>
{
    var application = await dbContext.Applications.Include(app => app.Announcement).FirstOrDefaultAsync(a => a.Id == applicationId);

    if (application is null)
        return Results.BadRequest("Application doesn't exist.");

    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    if (application.Announcement!.Pet.ShelterId != shelterId)
        return Results.Unauthorized();

    application.ApplicationStatus = ApplicationStatus.Accepted;
    await dbContext.SaveChangesAsync();
    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Accepts application. Requires shelter role matching with shelterId of application.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapPut("/applications/{applicationId}/reject", async (DataContext dbContext, Guid applicationId, HttpContext httpContext) =>
{
    var application = await dbContext.Applications.Include("Announcement").FirstOrDefaultAsync(a => a.Id == applicationId);

    if (application is null)
        return Results.BadRequest("Application doesn't exist.");

    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var shelterId = Guid.Parse(issuerClaim);

    if (application.Announcement!.Pet.ShelterId != shelterId)
        return Results.Unauthorized();

    application.ApplicationStatus = ApplicationStatus.Rejected;
    await dbContext.SaveChangesAsync();
    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("Shelter")
.WithSummary("Rejects application. Requires shelter role matching with shelterId of application.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.MapPut("/applications/{applicationId}/withdraw", async (DataContext dbContext, Guid applicationId, HttpContext httpContext) =>
{
    var application = await dbContext.Applications.FirstOrDefaultAsync(a => a.Id == applicationId);

    if (application is null)
        return Results.BadRequest("Application doesn't exist.");

    var identity = httpContext.User.Identity as ClaimsIdentity;
    var issuerClaim = identity?.GetIssuer();

    if (identity is null || issuerClaim is null)
        return Results.Unauthorized();

    var adopterId = Guid.Parse(issuerClaim);

    if (application.AdopterId != adopterId)
        return Results.Unauthorized();

    application.ApplicationStatus = ApplicationStatus.Withdrawn;
    await dbContext.SaveChangesAsync();
    return Results.Ok();
})
.WithOpenApi()
.RequireAuthorization("Adopter")
.WithSummary("Withdraws application. Requires adopter role matching with adopterId of application.")
.Produces(StatusCodes.Status200OK)
.Produces(StatusCodes.Status401Unauthorized)
.Produces(StatusCodes.Status400BadRequest);

app.Run();