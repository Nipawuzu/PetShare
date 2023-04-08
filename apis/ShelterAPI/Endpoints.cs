using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using ShelterAPI.Requests;
using ShelterAPI.Responses;

namespace ShelterAPI
{
    public static class Endpoints
    {
        public static async Task<IResult> GetShelter(DataContext context)
        {
            var shelters = await context.Shelters.Include("Address").Select(s => s.MapDTO()).ToArrayAsync();
            var res = new GetSheltersResponse(shelters);
            return Results.Ok(res);
        }

        public static async Task<IResult> GetShelters(DataContext context, Guid shelterId)
        {
            return await context.Shelters.Include("Address").FirstOrDefaultAsync(s => s.Id == shelterId) is Shelter shelter ?
                Results.Ok(new GetShelterResponse(shelter)) :
                Results.NotFound("Sorry, shelter not found");
        }

        public static async Task<IResult> PostShelter(DataContext context, PostShelterRequest shelter)
        {
            var newShelter = shelter.Map();

            if (shelter.Address != null)
            {
                var newAddress = shelter.Address.Map();
                context.Address.Add(newAddress);
                await context.SaveChangesAsync();
                newShelter.AddressId = newAddress.Id;
            }

            context.Shelters.Add(newShelter);
            await context.SaveChangesAsync();
            var res = new PostShelterResponse(newShelter.Id);
            return Results.Ok(res);
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
