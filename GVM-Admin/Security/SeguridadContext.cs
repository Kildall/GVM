using System.Configuration;
using GVM_Admin.Security.Entidades;
using Microsoft.EntityFrameworkCore;

namespace GVM_Admin.Security {
    public class SeguridadContext : DbContext {


        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) {
            optionsBuilder.UseLazyLoadingProxies()
                .UseSqlServer(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder) {
            modelBuilder.Entity<Entidad>()
                .HasDiscriminator<string>("Type")
                .HasValue<Rol>("Rol")
                .HasValue<Permiso>("Permiso");

            modelBuilder.Entity<Rol>()
                .HasMany(r => r.Permisos)
                .WithMany();
        }

        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Rol> Roles { get; set; }
        public DbSet<Permiso> Permisos { get; set; }
    }
}
