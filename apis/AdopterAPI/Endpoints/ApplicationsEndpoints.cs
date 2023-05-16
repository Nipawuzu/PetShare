﻿using AdopterAPI.Requests;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using CommonDTOLibrary.Mappers;
using EmailLibrary;
using Microsoft.Extensions.Configuration;

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
                case "shelter":
                    var shelterId = Guid.Parse(issuerClaim);
                    var applications = await dbContext.Applications
                        .Include("Announcement")
                        .Where(a => a.Announcement!.Pet.ShelterId == shelterId)
                        .ToListAsync();
                    return Results.Ok(applications.MapDTO());
                case "adopter":
                    var adopterId = Guid.Parse(issuerClaim);
                    applications = await dbContext.Applications
                        .Include("Announcement")
                        .Where(a => a.AdopterId == adopterId)
                        .ToListAsync();
                    return Results.Ok(applications.MapDTO());
                case "admin":
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

            if (!dbContext.Adopters.Any(adopter => adopter.Id == adopterId)) 
                return Results.NotFound();

            var newApplication = application.Map();
            newApplication.AdopterId = adopterId;

            dbContext.Applications.Add(newApplication);
            await dbContext.SaveChangesAsync();

            return Results.Created(newApplication.Id.ToString(), newApplication);
        }

        public static async Task<IResult> PutApplicationAccept(DataContext dbContext, Guid applicationId, HttpContext httpContext, IConfiguration configuration)
        {
            var application = await dbContext.Applications.Include(app => app.Announcement).Include(app => app.Adopter).Include(app => app.Announcement.Pet).FirstOrDefaultAsync(a => a.Id == applicationId);

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

            var emailSender = new ApplicationStatusChangedEmailSender(configuration);
            await emailSender.SendAcceptanceEmail(application.Adopter!.Email, application.Announcement!.Pet.Name);

            return Results.Ok();
        }

        public static async Task<IResult> PutApplicationReject(DataContext dbContext, Guid applicationId, HttpContext httpContext, IConfiguration configuration)
        {
            var application = await dbContext.Applications.Include(app => app.Announcement).Include(app => app.Adopter).Include(app => app.Announcement.Pet).FirstOrDefaultAsync(a => a.Id == applicationId);

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

            var emailSender = new ApplicationStatusChangedEmailSender(configuration);
            await emailSender.SendRejectionEmail(application.Adopter!.Email, application.Announcement!.Pet.Name);

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
