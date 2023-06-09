using DatabaseContextLibrary.models;
using DatabaseContextLibrary.Models;
using Microsoft.EntityFrameworkCore;

namespace AnnouncementsAPI
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {
        }

        public DbSet<Announcement> Announcements => Set<Announcement>();
        public DbSet<Pet> Pets => Set<Pet>();
        public DbSet<Shelter> Shelters => Set<Shelter>();
        public DbSet<Address> Address => Set<Address>();
        public DbSet<AdopterLikedAnnouncementsLinkingTable> AdopterLikedAnnouncementsLinkingTables => Set<AdopterLikedAnnouncementsLinkingTable>();
    }
}