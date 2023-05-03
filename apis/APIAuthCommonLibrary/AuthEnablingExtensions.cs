using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Microsoft.AspNetCore.DataProtection;

namespace APIAuthCommonLibrary
{
    public static class AuthEnablingExtensions
    {
        private const string SHELTER = "shelter";
        private const string ADMIN = "admin";
        private const string ADOPTER = "adopter";

        public static void AddSwaggerGenWithSecurity(this IServiceCollection services, string apiName, string apiVersion)
        {
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc(apiVersion, new OpenApiInfo
                {
                    Title = apiName,
                    Version = apiVersion
                });
                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
                {
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer",
                    BearerFormat = "JWT",
                    In = ParameterLocation.Header,
                    Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 1safsfsdfdfd\"",
                });
                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme {
                            Reference = new OpenApiReference {
                                Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                            }
                        },
                        new string[] {}
                    }
                });
            });
        }

        public static void AddCustomAuthentication(this IServiceCollection services, string audience, string authority, string secret = "")
        {
#if TEST
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, c =>
                {
                    c.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateAudience = false,
                        ValidateIssuer = false,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret)),
                    };
                });
#else
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
             .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, c =>
             {
                 c.Audience = audience;
                 c.Authority = authority;
                 c.TokenValidationParameters = new TokenValidationParameters()
                 {
                     ValidateIssuer = false,
                     ValidateIssuerSigningKey = false,
                 };
             });
#endif
        }

        public static void AddCustomAuthorization(this IServiceCollection services)
        {
            services.AddAuthorization(o =>
            {
                o.AddPolicy("Auth", p => p.
                    RequireAuthenticatedUser());
                o.AddPolicy("Shelter", p => p.
                    RequireAuthenticatedUser().
                    RequireRole(SHELTER));
                o.AddPolicy("ShelterOrAdmin", p => p.
                    RequireAuthenticatedUser().
                    RequireRole(SHELTER, ADMIN));
                o.AddPolicy("Admin", p => p.
                    RequireAuthenticatedUser().
                    RequireRole(ADMIN));
                o.AddPolicy("Adopter", p => p.
                    RequireAuthenticatedUser().
                    RequireRole(ADOPTER));
                o.AddPolicy("AdopterOrAdmin", p => p.
                    RequireAuthenticatedUser().
                    RequireRole(ADOPTER, ADMIN));
            });
        }
    }
}
