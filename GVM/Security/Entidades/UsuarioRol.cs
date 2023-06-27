using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace GVM.Security.Entidades {
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
