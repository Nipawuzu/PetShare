using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using ShelterAPI.Requests;
using CommonDTOLibrary.Mappers;

namespace ShelterAPI
{
    public static class Endpoints
    {
        public static async Task<IResult> GetShelters(DataContext context)
        {
            var shelters = await context.Shelters.Include("Address").Select(s => s.MapDTO()).ToArrayAsync();
            return Results.Ok(shelters);
        }

        public static async Task<IResult> GetShelter(DataContext context, Guid shelterId)
        {
            return await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId) is Shelter shelter ?
                Results.Ok(shelter.MapDTO()) :
                Results.NotFound("Sorry, shelter not found");
        }

        public static async Task<IResult> PostShelter(DataContext context, PostShelterRequest shelter)
        {
            var newShelter = shelter.Map();

            if (shelter.Address != null)
            {
                var newAddress = shelter.Address.MapDB();
                context.Address.Add(newAddress);
                await context.SaveChangesAsync();
                newShelter.AddressId = newAddress.Id;
            }

            context.Shelters.Add(newShelter);
            await context.SaveChangesAsync();
            return Results.Created(newShelter.Id.ToString(), null);
        }

        public static async Task<IResult> PutShelter(DataContext context, Guid shelterId, PutShelterRequest updatedShelter)
        {
            var shelter = await context.Shelters.FirstOrDefaultAsync(s => s.Id == shelterId);
            if (shelter is null)
                return Results.BadRequest("Sorry, this shelter doesn't exist.");

            shelter.IsAuthorized = updatedShelter.IsAuthorized;
            await context.SaveChangesAsync();

            return Results.Ok(await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId));
        }
    }
}
