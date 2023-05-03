using AdopterAPI.Requests;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using CommonDTOLibrary.Mappers;

namespace AdopterAPI.Endpoints
{
    public static class ApplicationsEndpoints
    {
        public static async Task<IResult> GetApplications(DataContext dbContext, HttpContext httpContext)
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
                    var applications = await dbContext.Applications
                        .Include("Announcement")
                        .Where(a => a.Announcement!.Pet.ShelterId == shelterId)
                        .ToListAsync();
                    return Results.Ok(applications.MapDTO());
                case "Adopter":
                    var adopterId = Guid.Parse(issuerClaim);
                    applications = await dbContext.Applications
                        .Include("Announcement")
                        .Where(a => a.AdopterId == adopterId)
                        .ToListAsync();
                    return Results.Ok(applications.MapDTO());
                case "Admin":
                    applications = await dbContext.Applications
                        .Include("Announcement")
                        .ToListAsync();
                    return Results.Ok(applications.MapDTO());
                default:
                    return Results.BadRequest();
            }
        }

        public static async Task<IResult> GetApplicationsForAnnouncement(DataContext dbContext, Guid announcementId, HttpContext httpContext)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();

            if (identity is null || issuerClaim is null)
                return Results.Unauthorized();

            var shelterId = Guid.Parse(issuerClaim);

            var applications = await dbContext.Applications.Include("Announcement").Where(a => a.AnnouncementId == announcementId).ToListAsync();

            if (applications.Any() && applications.First().Announcement!.Pet.ShelterId != shelterId)
                return Results.Unauthorized();

            return Results.Ok(applications.MapDTO());
        }

        public static async Task<IResult> PostApplication(DataContext dbContext, PostApplicationRequest application, HttpContext httpContext)
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
        }

        public static async Task<IResult> PutApplicationAccept(DataContext dbContext, Guid applicationId, HttpContext httpContext)
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
        }

        public static async Task<IResult> PutApplicationReject(DataContext dbContext, Guid applicationId, HttpContext httpContext)
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
        }

        public static async Task<IResult> PutApplicationWithdraw(DataContext dbContext, Guid applicationId, HttpContext httpContext)
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
        }
    }
}
