using GVM.Security.Entidades;
using System.ComponentModel.DataAnnotations.Schema;

namespace GVM.Security.Entidades {
    [Table("Permiso")]
    public class Permiso : EntidadSeguridad {
        public int PermisoId { get; set; }

        public Permiso(string nombre) : base(nombre) { }
        public override bool CheckeaPermiso(string nombrePermiso) {
            return Nombre == nombrePermiso;
        }
    }
}
