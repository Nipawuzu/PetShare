using AnnouncementsAPI.Requests;
using AnnouncementsAPI.Responses;
using APIAuthCommonLibrary;
using FileStorageLibrary;
using Microsoft.EntityFrameworkCore;

namespace AnnouncementsAPI.Endpoints
{
    public class PetEndpoints : Endpoints
    {
        public static async Task<IResult> GetAllForAuthorisedShelter(DataContext context, HttpContext httpContext)
        {
            if (!AuthorizeUser(httpContext, out _, out var userId))
                return Results.Unauthorized();

            var res = await context.Pets.Where(p => p.ShelterId == userId).Select(p => p.MapDTO()).ToListAsync();
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
            if (!AuthorizeUser(httpContext, out _, out var userId))
                return Results.Unauthorized();

            var pet = petRequest.Map();
            pet.ShelterId = userId;
            context.Pets.Add(pet);
            await context.SaveChangesAsync();

            return Results.Created(pet.Id.ToString(), pet.MapDTO());
        }

        public static async Task<IResult> Put(DataContext context, IStorage storage, PutPetRequest petRequest, Guid petId, HttpContext httpContext)
        {
            var pet = await context.Pets.FirstOrDefaultAsync(p => p.Id == petId);
            if (pet is null)
                return Results.NotFound("Pet doesn't exist.");

            if (!AuthorizeUser(httpContext, out var role, out var userId) || role == Role.Shelter && pet.ShelterId != userId)
                return Results.Unauthorized();

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

        public static async Task<IResult> UploadPhoto(IStorage storage, Guid petId, IFormFile file)
        {
            await storage.UploadFileAsync(file.OpenReadStream(), petId.ToString());
            return Results.Ok();
        }
    }
}
