using DatabaseContextLibrary.models;
using Microsoft.EntityFrameworkCore;

namespace ReportsAPI
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {
        }

        public DbSet<Report> Reports => Set<Report>();
    }
}