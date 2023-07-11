using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace GVM.Security.Entidades {

    [PrimaryKey(nameof(UsuarioId), nameof(EntidadId))]
    public class EntidadUsuario {
        public int UsuarioId { get; set; }
        public int EntidadId { get; set; }

        [ForeignKey("UsuarioId")]
        public virtual Usuario Usuario { get; set;}
        [ForeignKey("EntidadId")]
        public virtual Entidad Entidad { get; set; }
    }
}
