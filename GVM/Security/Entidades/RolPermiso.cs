using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Security.Entidades {
    [Table("RolPermiso")]
    [PrimaryKey(nameof(RolId), nameof(PermisoId))]
    public class RolPermiso {
        public int RolId { get; set; }
        public int PermisoId { get; set; }
        public virtual Rol Rol { get; set; }
        public virtual Permiso Permiso { get; set; }
    }
}
