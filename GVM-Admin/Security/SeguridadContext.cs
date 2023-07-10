using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GVM_Admin.Security.Entidades;

namespace GVM.Security {
    public class SeguridadContext : DbContext {


        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) {
            optionsBuilder.UseLazyLoadingProxies()
                .UseSqlServer(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
        }

        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Rol> Roles { get; set; }
        public DbSet<Permiso> Permisos { get; set; }
        public DbSet<UsuarioRol> UsuarioRoles { get; set; }
        public DbSet<RolPermiso> RolPermisos { get; set; }
    }
}
