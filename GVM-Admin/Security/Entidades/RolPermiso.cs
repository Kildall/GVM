using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace GVM_Admin.Security.Entidades {
    [Table("RolPermiso")]
    [PrimaryKey(nameof(RolId), nameof(PermisoId))]
    public class RolPermiso {
        public int RolId { get; set; }
        public int PermisoId { get; set; }
        public virtual Rol Rol { get; set; }
        public virtual Permiso Permiso { get; set; }
    }
}
