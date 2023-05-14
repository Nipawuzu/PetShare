global using Microsoft.EntityFrameworkCore;
using DatabaseContextLibrary.models;
using DatabaseContextLibrary.Models;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;

namespace DatabaseContextLibrary
{
    internal class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {
        }

        public DbSet<Shelter> Shelters => Set<Shelter>();
        public DbSet<Announcement> Announcements => Set<Announcement>();
        public DbSet<Pet> Pets => Set<Pet>();
        public DbSet<Adopter> Adopters => Set<Adopter>();
        public DbSet<AdopterShelterLinkingTable> AdopterShelterLinkingTable => Set<AdopterShelterLinkingTable>();
        public DbSet<Application> Applications => Set<Application>();
        public DbSet<AdopterLikedAnnouncementsLinkingTable> AdopterLikedAnnouncementsLinkingTables => Set<AdopterLikedAnnouncementsLinkingTable>();
    }


    internal class DataContextFactory : IDesignTimeDbContextFactory<DataContext>
    {
        public DataContextFactory()
        {

        }

        public DataContext CreateDbContext(string[] args)
        {
            string connectionString = "Server=tcp:petshareserver2.database.windows.net,1433;Initial Catalog=PetShareDatabase;Persist Security Info=False;User ID=azureuser;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

            var optionsBuilder = new DbContextOptionsBuilder<DataContext>();
            optionsBuilder.UseSqlServer(connectionString);

            return new DataContext(optionsBuilder.Options);
        }
    }
}
