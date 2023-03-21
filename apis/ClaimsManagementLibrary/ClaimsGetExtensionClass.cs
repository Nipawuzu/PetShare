using System.Security.Claims;

namespace ClaimsManagementLibrary
{
    public static class ClaimsGetExtensionClass
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