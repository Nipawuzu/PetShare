using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using ShelterAPI.Requests;
using CommonDTOLibrary.Mappers;
using ShelterAPI.Responses;

namespace ShelterAPI
{
    public static class Endpoints
    {
        private const int DEFAULT_PAGE_COUNT = 100;

        public static async Task<IResult> GetShelters(DataContext context, int? pageNumber, int? pageCount)
        {
            var shelters = context.Shelters.Include(s => s.Address);

            int pageNumberVal = pageNumber ?? 0;
            int pageCountVal = pageCount ?? DEFAULT_PAGE_COUNT;

            int count = shelters.Count();

            var res = await shelters
                .Skip(pageNumberVal * pageCountVal).Take(pageCountVal)
                .Select(s => s.MapDTO()).ToArrayAsync();

            return Results.Ok(new GetSheltersResponse()
            {
                Shelters = res,
                PageNumber = pageNumberVal,
                Count = count
            });
        }

        public static async Task<IResult> GetShelter(DataContext context, Guid shelterId)
        {
            return await context.Shelters.Include(s => s.Address).FirstOrDefaultAsync(s => s.Id == shelterId) is Shelter shelter ?
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

            return Results.Ok(await context.Shelters.Include(s => s.Address).FirstOrDefaultAsync(s => s.Id == shelterId));
        }
    }
}
