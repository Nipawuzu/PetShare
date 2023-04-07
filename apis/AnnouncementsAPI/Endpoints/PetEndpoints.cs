using AnnouncementsAPI.Requests;
using AnnouncementsAPI.Responses;
using APIAuthCommonLibrary;
using FileStorageLibrary;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace AnnouncementsAPI.Endpoints
{
    public class PetEndpoints
    {
        public static async Task<IResult> GetAllForAuthorisedShelter(DataContext context, HttpContext httpContext)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();

            if (identity is null || issuerClaim is null)
                return Results.Unauthorized();

            var shelterId = Guid.Parse(issuerClaim);

            var res = await context.Pets.Where(p => p.ShelterId == shelterId).ToListAsync();
            return Results.Ok(res);
        }

        public static async Task<IResult> GetById(DataContext context, IStorage storage, Guid petId)
        {
            var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
            if (pet is null)
                return Results.NotFound("Pet doesn't exist.");

            var res = new GetPetResponse(pet, await pet.GetPhotoUrl(storage));
            return Results.Ok(res);
        }

        public static async Task<IResult> Post(DataContext context, PostPetRequest petRequest, HttpContext httpContext)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();

            if (identity is null || issuerClaim is null)
                return Results.Unauthorized();

            var shelterId = Guid.Parse(issuerClaim);

            var pet = petRequest.Map();
            pet.ShelterId = shelterId;
            context.Pets.Add(pet);
            await context.SaveChangesAsync();

            var res = new PostPetResponse() { Id = pet.Id };
            return Results.Ok(res);
        }

        public static async Task<IResult> Put(DataContext context, IStorage storage, PutPetRequest petRequest, Guid petId, HttpContext httpContext)
        {
            var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
            if (pet is null)
                return Results.NotFound("Pet doesn't exist.");

            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();
            var roleClaim = identity?.GetRole();

            if (identity is null || issuerClaim is null || roleClaim is null)
                return Results.Unauthorized();

            if (roleClaim == "Shelter")
            {
                var shelterId = Guid.Parse(issuerClaim);
                if (pet.ShelterId != shelterId)
                    return Results.Unauthorized();
            }

            if (petRequest.Name != null)
                pet.Name = petRequest.Name;
            if (petRequest.Description != null)
                pet.Description = petRequest.Description;
            if (petRequest.Species != null)
                pet.Species = petRequest.Species;
            if (petRequest.Breed != null)
                pet.Breed = petRequest.Breed;
            if (petRequest.Birthday != null)
                pet.Birthday = petRequest.Birthday.Value;

            await context.SaveChangesAsync();
            return Results.Ok();
        }

        public static async Task<IResult> UploadPhoto(IStorage storage, HttpContext context, Guid petId, IFormFile file)
        {
            await storage.UploadFileAsync(file.OpenReadStream(), petId.ToString());
            return Results.Ok();
        }
    }
}
