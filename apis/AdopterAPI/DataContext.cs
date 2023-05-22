using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;

namespace AdopterAPI
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {
        }

        public DbSet<Adopter> Adopters => Set<Adopter>();
        public DbSet<AdopterShelterLinkingTable> AdopterShelterLinkingTable => Set<AdopterShelterLinkingTable>();
        public DbSet<Address> Address => Set<Address>();
        public DbSet<Application> Applications => Set<Application>();
        private DbSet<Announcement> Announcements => Set<Announcement>();
        private DbSet<Pet> Pets => Set<Pet>();
        private DbSet<Shelter> Shelters => Set<Shelter>();
    }
}