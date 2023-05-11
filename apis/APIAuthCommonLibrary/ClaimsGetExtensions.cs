using System.Security.Claims;

namespace APIAuthCommonLibrary
{
    public static class ClaimsGetExtensions
    {
        public static string? GetIssuer(this ClaimsIdentity identity)
        {
            return identity.FindFirst("db_id")?.Value;
        }

        public static string? GetRole(this ClaimsIdentity identity)
        {
            return identity.FindFirst(ClaimTypes.Role)?.Value;
        }
    }
}