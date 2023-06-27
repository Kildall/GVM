using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GVM.Security.Entidades;
using GVM.Security;
using GVM.Utils.Errors;
using Microsoft.EntityFrameworkCore;


namespace GVM.Services {
    public class SeguridadService {
        private readonly SeguridadContext _seguridadContext;
        public bool EstaLogeado { get; private set; }
        public Usuario Usuario { get; private set; }

        public event Action OnChange;

        public SeguridadService(SeguridadContext context) {
            _seguridadContext = context;
            if (!_seguridadContext.Database.CanConnect()) {
                throw new Exception("Servicio de autenticacion no disponible.");
            }
        }

        public async Task<bool> RegistrarAsync(string nombre, string email, string clave) {
            try {
                var user = new Usuario(nombre) { Email = email, Clave = HashClave(clave), Habilitado = false };
                _seguridadContext.Usuarios.Add(user);
                await _seguridadContext.SaveChangesAsync();
                return true;
            } catch (Exception e) {
                return false;
            }
        }

        public async Task<Usuario> ValidarLoginAsync(string email, string clave) {
                Usuario user = await _seguridadContext.Usuarios
                    .SingleOrDefaultAsync(u => u.Email == email);

                if (user == null) {
                    throw new EmailNotFoundException(email);
                }

                if (!ValidarClave(user.Clave, clave)) {
                    throw new IncorrectPasswordException("Contraseña incorrecta");
                }

                if (!EstaLogeado) {
                    EstaLogeado = true;
                    Usuario = user;
                    NotifyStateChanged();
                }
                return user;


        }

        public bool ValidarPermiso(string permiso) {
            return Usuario.CheckeaPermiso(permiso);
        }

        private string HashClave(string clave) {
            string salt = BCrypt.Net.BCrypt.GenerateSalt();
            return BCrypt.Net.BCrypt.HashPassword(clave, salt);
        }

        private bool ValidarClave(string hash, string plain) {
            return BCrypt.Net.BCrypt.Verify(plain, hash);
        }

        private void NotifyStateChanged() => OnChange?.Invoke();
    }
}
