using AnnouncementsAPI.Requests;
using APIAuthCommonLibrary;
using FileStorageLibrary;
using Microsoft.EntityFrameworkCore;
using CommonDTOLibrary.Mappers;
using AnnouncementsAPI.Responses;
using DatabaseContextLibrary.models;
using Microsoft.Identity.Client.Extensions.Msal;

namespace AnnouncementsAPI.Endpoints
{
    public class PetEndpoints : Endpoints
    {
        private const int DEFAULT_PAGE_COUNT = 100;

        public static async Task<IResult> GetAllForAuthorisedShelter(DataContext context, HttpContext httpContext, int? pageNumber, int? pageCount)
        {
            if (!AuthorizeUser(httpContext, out _, out var userId))
                return Results.Unauthorized();

            var pets = context.Pets
                .Include(x => x.Shelter)
                .ThenInclude(x => x.Address)
                .Where(p => p.ShelterId == userId);

            int pageNumberVal = pageNumber ?? 0;
            int pageCountVal = pageCount ?? DEFAULT_PAGE_COUNT;

            int count = pets.Count();

            var res = await pets
                .Skip(pageNumberVal * pageCountVal).Take(pageCountVal)
                .Select(a => a.MapDTO()).ToListAsync();

            return Results.Ok(new GetPetsResponse()
            {
                Pets = res.ToArray(),
                PageNumber = pageNumberVal,
                Count = count
            });
        }

        public static async Task<IResult> GetById(DataContext context, IStorage storage, Guid petId)
        {
            var pet = await context.Pets
                .Include(x => x.Shelter)
                .ThenInclude(x => x.Address)
                .FirstOrDefaultAsync(p => p.Id == petId);

            if (pet is null)
                return Results.NotFound("Pet doesn't exist.");

            var res = pet.MapDTO();
            await res.AttachPhotoUrl(storage);
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

            return Results.Created(pet.Id.ToString(), null);
        }

        public static async Task<IResult> Put(DataContext context, PutPetRequest petRequest, Guid petId, HttpContext httpContext)
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
