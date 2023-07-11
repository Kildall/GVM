using GVM.Security.Entidades;
using Microsoft.EntityFrameworkCore;

namespace GVM.Security {
    public class SeguridadContext : DbContext {
        public SeguridadContext(DbContextOptions<SeguridadContext> options) : base(options) {
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
