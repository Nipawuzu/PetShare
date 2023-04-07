using AnnouncementsAPI.Requests;
using AnnouncementsAPI.Responses;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using FileStorageLibrary;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace AnnouncementsAPI.Endpoints
{
    public class AnnouncementsEndpoints
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
            res.Pet.AttachPhotoUrl(storage);

            return Results.Ok(announcement);
        }


        public static async Task<IResult> Post(
            DataContext context,
            IStorage storage,
            PostAnnouncementRequest announcement,
            HttpContext httpContext)
        {
            var newAnnouncement = announcement.Map();


            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();

            if (identity is null || issuerClaim is null)
                return Results.Unauthorized();

            var shelterId = Guid.Parse(issuerClaim);

            if (announcement.PetId.HasValue)
            {
                var pet = await context.Pets.FindAsync(announcement.PetId);
                if (pet == null)
                    return Results.BadRequest("Announcement's pet doesn't exist");

                if (pet.ShelterId != shelterId)
                    return Results.Unauthorized();

                newAnnouncement.PetId = announcement.PetId.Value;
            }
            else if (announcement.Pet != null)
            {
                var pet = announcement.Pet.Map();
                pet.ShelterId = shelterId;
                context.Pets.Add(pet);
                await context.SaveChangesAsync();
                await pet.UploadPhoto(announcement.Pet.Photo, storage);
                newAnnouncement.PetId = pet.Id;
            }

            context.Announcements.Add(newAnnouncement);
            await context.SaveChangesAsync();

            var res = new PostAnnouncementResponse() { Id = newAnnouncement.Id };
            return Results.Ok(res);
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

            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();
            var roleClaim = identity?.GetRole();

            if (identity is null || issuerClaim is null || roleClaim is null)
                return Results.Unauthorized();

            var shelterId = Guid.Parse(issuerClaim);

            Pet? announcementPet;
            if (announcementRequest.PetId != null)
            {
                announcementPet = await context.Pets.FirstOrDefaultAsync(p => p.Id == announcementRequest.PetId);

                if (announcementPet is null)
                    return Results.BadRequest("Announcement's pet doesn't exist.");
            }
            else
                announcementPet = announcement.Pet;


            if (roleClaim == "Shelter" && announcementPet.ShelterId != shelterId)
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
