using APIAuthCommonLibrary;
using System.Security.Claims;

namespace AnnouncementsAPI.Endpoints
{
#warning TODO: Przenieść gdzieś bazowość endpoints
    public class Endpoints
    {
        protected static bool AuthorizeUser(HttpContext httpContext, out Role role, out Guid id)
        {
            var identity = httpContext.User.Identity as ClaimsIdentity;
            var issuerClaim = identity?.GetIssuer();
            var roleClaim = identity?.GetRole();
            if (!Enum.TryParse(roleClaim, true, out role)) role = Role.None;
            return Guid.TryParse(issuerClaim, out id);
        }
    }
}
