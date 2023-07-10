using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace GVM_Admin.Security.Entidades {
    [Table("UsuarioRol")]
    [PrimaryKey(nameof(UsuarioId), nameof(RolId))]
    public class UsuarioRol {
        public int UsuarioId { get; set; }
        public int RolId { get; set; }

        [ForeignKey("UsuarioId")]
        public virtual Usuario Usuario { get; set; }

        [ForeignKey("RolId")]
        public virtual Rol Rol { get; set; }

    }
}
