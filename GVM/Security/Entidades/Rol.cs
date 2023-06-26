using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Security.Entidades {
    [Table("Rol")]
    public class Rol : EntidadSeguridad {
        public int RolId { get; set; }
        public IEnumerable<RolPermiso> Permisos { get; set; }

        public Rol(string nombre) : base(nombre) { }
        public override bool CheckeaPermiso(string nombrePermiso) {
            return Permisos.Any(permiso => permiso.Permiso.CheckeaPermiso(nombrePermiso));
        }
    }
}
