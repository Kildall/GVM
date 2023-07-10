using System.ComponentModel.DataAnnotations.Schema;

namespace GVM_Admin.Security.Entidades {
    [Table("Rol")]
    public class Rol : EntidadSeguridad {
        public int RolId { get; set; }
        public virtual IEnumerable<RolPermiso> Permisos { get; set; }

        public Rol(string nombre) : base(nombre) { }
        public override bool CheckeaPermiso(string nombrePermiso) {
            return Permisos.Any(permiso => permiso.Permiso.CheckeaPermiso(nombrePermiso));
        }
    }
}
