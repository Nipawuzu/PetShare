using AdopterAPI.Requests;
using APIAuthCommonLibrary;
using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using CommonDTOLibrary.Mappers;

namespace AdopterAPI.Endpoints
{
    public static class AdopterEndpoints
    {
        public static async Task<IResult> GetAdopters(DataContext dbContext)
        {
            var adopters = await dbContext.Adopters.Include(nameof(Adopter.Address)).ToListAsync();
            return Results.Ok(adopters.MapDTO().ToList());
        }

        public static async Task<IResult> GetAdopter(DataContext dbContext, Guid adopterId, HttpContext httpContext)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();
            var roleClaim = identity?.GetRole();

            if (identity is null || issuerClaim is null || roleClaim is null)
                return Results.Unauthorized();

            if (roleClaim == "Adopter")
            {
                var claimAdopterId = Guid.Parse(issuerClaim);
                if (claimAdopterId != adopterId)
                    return Results.Unauthorized();
            }


            var adopter = await dbContext.Adopters.Include(nameof(Adopter.Address)).FirstOrDefaultAsync(a => a.Id == adopterId);
            if (adopter is null) return Results.NotFound("Adopter doesn't exist.");
            return Results.Ok(adopter.MapDTO());
        }

        public static async Task<IResult> PostAdopter(DataContext dbContext, PostAdopterRequest adopter)
        {
            var newAdopter = adopter.Map();

            if (adopter.Address != null)
            {
                var newAddress = adopter.Address.MapDB();
                dbContext.Address.Add(newAddress);
                await dbContext.SaveChangesAsync();
                newAdopter.AddressId = newAddress.Id;
            }

            dbContext.Adopters.Add(newAdopter);
            await dbContext.SaveChangesAsync();
            return Results.Created(newAdopter.Id.ToString(), newAdopter.MapDTO());
        }

        public static async Task<IResult> PutAdopter(DataContext dbContext, Guid adopterId, PutAdopterRequest updatedAdopter)
        {
            var adopter = await dbContext.Adopters.Include("Address").FirstOrDefaultAsync(a => a.Id == adopterId);
            if (adopter is null)
                return Results.BadRequest("Adopter doesn't exist.");

            if (adopter.Status != updatedAdopter.Status)
            {
                adopter.Status = updatedAdopter.Status;
                await dbContext.SaveChangesAsync();
            }

            return Results.Ok(adopter.MapDTO());
        }

        public static async Task<IResult> GetAdopterVerified(DataContext dbContext, Guid adopterId, HttpContext httpContext)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();

            if (identity is null || issuerClaim is null)
                return Results.Unauthorized();

            var shelterId = Guid.Parse(issuerClaim);

            bool isVerified = await dbContext.AdopterShelterLinkingTable.AnyAsync(aslt => aslt.AdopterId == adopterId && aslt.ShelterId == shelterId);
            return Results.Ok(isVerified);
        }

        public static async Task<IResult> PutAdopterVerified(DataContext dbContext, Guid adopterId, HttpContext httpContext)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();

            if (identity is null || issuerClaim is null)
                return Results.Unauthorized();

            var shelterId = Guid.Parse(issuerClaim);

            var verified = await dbContext.AdopterShelterLinkingTable.FirstOrDefaultAsync(aslt => aslt.AdopterId == adopterId && aslt.ShelterId == shelterId);

            if (verified != null)
                return Results.BadRequest("Adopter already verified.");

            dbContext.AdopterShelterLinkingTable.Add(new AdopterShelterLinkingTable()
            {
                AdopterId = adopterId,
                ShelterId = shelterId
            });
            await dbContext.SaveChangesAsync();

            return Results.Ok();
        }
    }
}
