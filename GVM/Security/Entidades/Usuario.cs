using System.ComponentModel.DataAnnotations;

namespace GVM.Security.Entidades {

    public class Usuario {
        public int UsuarioId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Nombre { get; set; }
        
        [Required]
        [MaxLength(50)]
        [EmailAddress]
        public string Email { get; set; }

        [MaxLength(256)]
        [Required]
        public string Clave { get; set; }
        public bool Habilitado { get; set; }
        public virtual ICollection<EntidadUsuario> Permisos { get; set; } = new List<EntidadUsuario>();

        public bool CheckeaPermiso(string nombrePermiso) {
            return Permisos.Any(rol => rol.Entidad.CheckeaPermiso(nombrePermiso));
        }
    }
}
