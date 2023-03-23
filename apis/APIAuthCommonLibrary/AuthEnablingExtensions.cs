using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

namespace APIAuthCommonLibrary
{
    public static class AuthEnablingExtensions
    {
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

        public static void AddCustomAuthentication(this IServiceCollection services, string secret)
        {
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
             .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, c =>
             {
#warning tym zakomentowanym będziemy się przejmować po zrobieniu Auth0
                 //c.Authority = $"https://{builder.Configuration["Auth0:Domain"]}";
                 c.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
                 {
                     ValidateAudience = false,
                     ValidateIssuer = false,
                     IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret)),
                     //ValidAudience = builder.Configuration["Auth0:Audience"],
                     //ValidIssuer = $"{builder.Configuration["Auth0:Domain"]}"
                 };
             });
        }

        public static void AddCustomAuthorization(this IServiceCollection services)
        {
            services.AddAuthorization(o =>
            {
                o.AddPolicy("Auth", p => p.
                    RequireAuthenticatedUser());
                o.AddPolicy("Shelter", p => p.
                    RequireAuthenticatedUser().
                    RequireRole("Shelter"));
                o.AddPolicy("ShelterOrAdmin", p => p.
                    RequireAuthenticatedUser().
                    RequireRole("Shelter", "Admin"));
                o.AddPolicy("Admin", p => p.
                    RequireAuthenticatedUser().
                    RequireRole("Admin"));
            });
        }
    }
}
