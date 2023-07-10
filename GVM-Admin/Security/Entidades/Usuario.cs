using System.ComponentModel.DataAnnotations.Schema;

namespace GVM_Admin.Security.Entidades {
    [Table("Usuario")]
    public class Usuario : EntidadSeguridad {
        public int UsuarioId { get; set; }
        public string Email { get; set; }
        public string Clave { get; set; }
        public bool Habilitado { get; set; }
        public virtual ICollection<UsuarioRol> Roles { get; set; }


        public Usuario(string nombre) : base(nombre) { }

        public override bool CheckeaPermiso(string nombrePermiso) {
            if (Roles == null) {
                return false;
            }
            return Roles.Any(rol => rol.Rol.CheckeaPermiso(nombrePermiso));
        }
    }
}
