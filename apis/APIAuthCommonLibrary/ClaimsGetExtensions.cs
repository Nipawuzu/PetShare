using System.Security.Claims;

namespace APIAuthCommonLibrary
{
    public static class ClaimsGetExtensions
    {
        public static string? GetIssuer(this ClaimsIdentity identity)
        {
            return identity.FindFirst("iss")?.Value;
        }

        public static string? GetRole(this ClaimsIdentity identity)
        {
            return identity.FindFirst("http://schemas.microsoft.com/ws/2008/06/identity/claims/role")?.Value;
        }
    }
}