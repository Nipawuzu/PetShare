﻿using AnnouncementsAPI.Requests;
using AnnouncementsAPI.Responses;
using APIAuthCommonLibrary;
using CommonDTOLibrary.Mappers;
using DatabaseContextLibrary.models;
using DatabaseContextLibrary.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;

namespace AnnouncementsAPI.Endpoints
{
    public class AnnouncementsEndpoints : Endpoints
    {
        private const int DEFAULT_PAGE_COUNT = 100;

        public static async Task<IResult> GetWithFilters(
            DataContext context,
            int? pageNumber,
            int? pageCount,
            string[]? species,
            string[]? breeds,
            string[]? locations,
            int? minAge,
            int? maxAge,
            string[]? shelterNames,
            bool? isLiked,
            AnnouncementStatus? status,
            HttpContext httpContext)
        {
            var isAdopter = false;
            if (AuthorizeUser(httpContext, out var role, out var adopterId) && role == Role.Adopter)
            {
                isAdopter = true;
            }

            var announcements = context.Announcements
                .Include(a => a.Pet)
                .ThenInclude(p => p!.Shelter)
                .ThenInclude(s => s!.Address)
                .AsQueryable();

            if (ShouldApplyFilter(species))
                announcements = announcements.Where(a => species.Contains(a.Pet.Species));

            if (ShouldApplyFilter(breeds))
                announcements = announcements.Where(a => breeds.Contains(a.Pet.Breed));

            if (ShouldApplyFilter(locations))
                announcements = announcements.Where(a => locations.Contains(a.Pet.Shelter.Address.City));

            announcements = announcements.Where(
                a => (minAge == null || a.Pet.Birthday <= DateTime.Now.AddDays(-(double)minAge))
                    && (maxAge == null || a.Pet.Birthday >= DateTime.Now.AddDays(-(double)maxAge)));

            if (ShouldApplyFilter(shelterNames))
                announcements = announcements.Where(a => shelterNames.Contains(a.Pet.Shelter.FullShelterName));

            if (status != null)
                announcements = announcements.Where(a => a.Status == status);

            if (isAdopter && isLiked.HasValue)
            {
                if (isLiked.Value)
                    announcements = announcements.Where(a => context.AdopterLikedAnnouncementsLinkingTables.Any(
                            alalt => alalt.AnnouncementId == a.Id && alalt.AdopterId == adopterId));
                else
                    announcements = announcements.Where(a => !context.AdopterLikedAnnouncementsLinkingTables.Any(
                        alalt => alalt.AnnouncementId == a.Id && alalt.AdopterId == adopterId));
            }
            int pageNumberVal = pageNumber ?? 0;
            int pageCountVal = pageCount ?? DEFAULT_PAGE_COUNT;

            int count = announcements.Count();

            var res = await announcements
                .Skip(pageNumberVal * pageCountVal).Take(pageCountVal)
                .Select(a => a.MapDTO()).ToListAsync();

            foreach (var a in res)
            {
                if (isAdopter)
                {
                    a.IsLiked = await context.AdopterLikedAnnouncementsLinkingTables.AnyAsync(
                        alalt => alalt.AnnouncementId == a.Id && alalt.AdopterId == adopterId);
                }
            }

            return Results.Ok(new GetAnnouncementsReponse()
            {
                Announcements = res.ToArray(),
                PageNumber = pageNumberVal,
                Count = count
            });
        }

        private static bool ShouldApplyFilter(string[]? filter)
            => (filter != null && filter.Any() && !filter.Where(a => !a.IsNullOrEmpty()).IsNullOrEmpty());

        public static async Task<IResult> GetById(
            DataContext context,
            Guid announcementId)
        {
            var announcement = await context.Announcements
                .Include(a => a.Pet)
                .ThenInclude(p => p!.Shelter)
                .ThenInclude(s => s!.Address)
                .FirstOrDefaultAsync(a => a.Id == announcementId);

            if (announcement is null)
                return Results.NotFound("Announcement doesn't exist.");

            var res = announcement.MapDTO();
            return Results.Ok(res);
        }

        public static async Task<IResult> GetForAuthorisedShelter(
            DataContext context,
            HttpContext httpContext,
            int? pageNumber,
            int? pageCount)
        {
            if (!AuthorizeUser(httpContext, out var role, out var userId) || role != Role.Shelter)
                return Results.Unauthorized();

            var announcements = context.Announcements
                .Include(a => a.Pet)
                .ThenInclude(p => p!.Shelter)
                .ThenInclude(s => s!.Address)
                .Where(x => x.Pet.ShelterId == userId);

            int pageNumberVal = pageNumber ?? 0;
            int pageCountVal = pageCount ?? DEFAULT_PAGE_COUNT;

            int count = announcements.Count();

            var res = await announcements
                .Skip(pageNumberVal * pageCountVal).Take(pageCountVal)
                .Select(a => a.MapDTO()).ToListAsync();

            return Results.Ok(new GetAnnouncementsReponse()
            {
                Announcements = res.ToArray(),
                PageNumber = pageNumberVal,
                Count = count
            });
        }

        public static async Task<IResult> Post(
            DataContext context,
            PostAnnouncementRequest announcement,
            HttpContext httpContext)
        {
            var newAnnouncement = announcement.Map();

            if (!AuthorizeUser(httpContext, out var role, out var userId) || role != Role.Shelter)
                return Results.Unauthorized();

            var pet = await context.Pets.FindAsync(announcement.PetId);

            if (pet == null) return Results.BadRequest("Announcement's pet doesn't exist");
            if (pet.ShelterId != userId) return Results.Unauthorized();

            newAnnouncement.PetId = announcement.PetId;
            context.Announcements.Add(newAnnouncement);
            await context.SaveChangesAsync();

            return Results.Created(newAnnouncement.Id.ToString(), null);
        }

        public static async Task<IResult> Put(
            DataContext context,
            PutAnnouncementRequest announcementRequest,
            Guid announcementId,
            HttpContext httpContext)
        {
            var announcement = await context.Announcements
                .Include(a => a.Pet)
                .ThenInclude(p => p!.Shelter)
                .ThenInclude(s => s!.Address)
                .FirstOrDefaultAsync(a => a.Id == announcementId);

            if (announcement is null)
                return Results.NotFound("Announcement doesn't exist.");

            if (!AuthorizeUser(httpContext, out var role, out var userId))
                return Results.Unauthorized();

            Pet? announcementPet;
            if (announcementRequest.PetId != null)
            {
                announcementPet = await context.Pets.FirstOrDefaultAsync(p => p.Id == announcementRequest.PetId);

                if (announcementPet is null)
                    return Results.BadRequest("Announcement's pet doesn't exist.");
            }
            else
                announcementPet = announcement.Pet;

            if (role == Role.Shelter && announcementPet.ShelterId != userId)
                return Results.Unauthorized();

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
        }

        public static async Task<IResult> PutLiked(DataContext dbContext, Guid announcementId, bool isLiked, HttpContext httpContext)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();

            if (identity is null || issuerClaim is null)
                return Results.Forbid();

            var adopterId = Guid.Parse(issuerClaim);
            var announcement = await dbContext.Announcements.FirstOrDefaultAsync(a => a.Id == announcementId);

            if (announcement is null)
                return Results.NotFound("Announcement doesn't exist.");

            if (isLiked)
            {
                var liked = await dbContext.AdopterLikedAnnouncementsLinkingTables.FirstOrDefaultAsync(alalt =>
                    alalt.AdopterId == adopterId && alalt.AnnouncementId == announcementId);

                if (liked != null)
                    return Results.Ok();

                dbContext.AdopterLikedAnnouncementsLinkingTables.Add(new AdopterLikedAnnouncementsLinkingTable()
                {
                    AdopterId = adopterId,
                    AnnouncementId = announcementId
                });
                await dbContext.SaveChangesAsync();
            }
            else
            {
                var liked = await dbContext.AdopterLikedAnnouncementsLinkingTables.FirstOrDefaultAsync(alalt =>
                   alalt.AdopterId == adopterId && alalt.AnnouncementId == announcementId);

                if (liked == null)
                    return Results.Ok();

                dbContext.AdopterLikedAnnouncementsLinkingTables.Remove(liked!);
                await dbContext.SaveChangesAsync();
            }

            return Results.Ok();
        }
    }
}
