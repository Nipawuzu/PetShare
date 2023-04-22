using AnnouncementsAPI.Requests;
using AnnouncementsAPI.Responses;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using FileStorageLibrary;
using Microsoft.EntityFrameworkCore;

namespace AnnouncementsAPI.Endpoints
{
    public class AnnouncementsEndpoints : Endpoints
    {
        public static async Task<IResult> GetWithFilters(
            DataContext context,
            IStorage storage,
            string[]? species,
            string[]? breeds,
            string[]? locations,
            int? minAge,
            int? maxAge,
            string[]? shelterNames)
        {
            var announcements = context.Announcements.Include(x => x.Pet)
                .ThenInclude(x => x.Shelter).ThenInclude(x => x.Address).AsQueryable();

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

            var res = await announcements.Select(a => a.MapDTO()).ToListAsync();

            foreach (var a in res)
            {
                await a.Pet.AttachPhotoUrl(storage);
            }

            return Results.Ok(res);
        }

        public static async Task<IResult> GetById(
            DataContext context,
            IStorage storage,
            Guid announcementId)
        {
            var announcement = await context.Announcements.Include("Pet").FirstOrDefaultAsync(a => a.Id == announcementId);

            if (announcement is null)
                return Results.NotFound("Announcement doesn't exist.");

            var res = new GetAnnouncementResponse(announcement);
            await res.Pet.AttachPhotoUrl(storage);
            return Results.Ok(res);
        }

        public static async Task<IResult> GetForAuthorisedShelter(
            DataContext context,
            IStorage storage,
            HttpContext httpContext)
        {
            if (!AuthorizeUser(httpContext, out var role, out var userId) || role != Role.Shelter)
                return Results.Unauthorized();

            var announcements = context.Announcements.Include(x => x.Pet)
                .ThenInclude(x => x.Shelter).ThenInclude(x => x.Address).Where(x => x.Pet.ShelterId == userId);

            var res = await announcements.Select(a => a.MapDTO()).ToListAsync();
            foreach (var a in res) await a.Pet.AttachPhotoUrl(storage);

            return Results.Ok(res);
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

            return Results.Created(newAnnouncement.Id.ToString(), newAnnouncement.MapDTO());
        }

        public static async Task<IResult> Put(
            DataContext context,
            PutAnnouncementRequest announcementRequest,
            Guid announcementId,
            HttpContext httpContext)
        {
            var announcement = await context.Announcements.Include("Pet").FirstOrDefaultAsync(a => a.Id == announcementId);

            if (announcement is null)
                return Results.NotFound("Announcement doesn't exist.");

            if(!AuthorizeUser(httpContext, out var role, out var userId))
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
    }
}
