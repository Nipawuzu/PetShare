using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;

namespace ShelterAPI
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {
        }

        public DbSet<Shelter> Shelters => Set<Shelter>();
    }
}