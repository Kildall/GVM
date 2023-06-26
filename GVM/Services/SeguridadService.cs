using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GVM.Security.Entidades;
using GVM.Security;
using Microsoft.EntityFrameworkCore;


namespace GVM.Services {
    public class SeguridadService {
        private readonly SeguridadContext _seguridadContext;
        public bool EstaLogeado { get; private set; }
        public Usuario Usuario { get; private set; }
        public event Action OnChange;

        public SeguridadService(SeguridadContext context) {
            _seguridadContext = context;
        }

        public async Task<Usuario> RegisterAsync(string nombre, string email, string clave) {
            var user = new Usuario(nombre) { Email = email, Clave = HashPassword(clave) };
            _seguridadContext.Usuarios.Add(user);
            await _seguridadContext.SaveChangesAsync();
            return user;
        }

        public async Task<Usuario> ValidateLoginAsync(string email, string password) {
            try {

                Usuario user = await _seguridadContext.Usuarios.SingleOrDefaultAsync(u => u.Email == email);
                if (user == null) {
                    return null;
                }

                if (!ValidatePasword(user.Clave, password)) {
                    return null;
                }

                if (!EstaLogeado) {
                    EstaLogeado = false;
                    Usuario = user;
                    NotifyStateChanged();
                }

                return user;
            } catch (Exception e) {
                Console.WriteLine(e);
                throw;
            }

        }

        public async Task<bool> ValidatePermissionAsync(int userId, string permission) {
            return await _seguridadContext.UsuarioRoles
                .Where(ur => ur.UsuarioId == userId)
                .SelectMany(ur => _seguridadContext.RolPermisos.Where(rp => rp.RolId == ur.RolId))
                .AnyAsync(rp => _seguridadContext.Permisos.Any(p => p.PermisoId == rp.PermisoId && p.Nombre == permission));
        }

        private string HashPassword(string password) {
            string salt = BCrypt.Net.BCrypt.GenerateSalt();
            return BCrypt.Net.BCrypt.HashPassword(password, salt);
        }

        private bool ValidatePasword(string hash, string plain) {
            return BCrypt.Net.BCrypt.Verify(plain, hash);
        }

        private void NotifyStateChanged() => OnChange?.Invoke();
    }
}
