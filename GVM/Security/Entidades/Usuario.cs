using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Security.Entidades {
    [Table("Usuario")]
    public class Usuario : EntidadSeguridad {
        public int UsuarioId { get; set; }
        public string Email { get; set; }
        public string Clave { get; set; }
        public ICollection<UsuarioRol> Roles { get; set; }


        public Usuario(string nombre) : base(nombre) { }

        public override bool CheckeaPermiso(string nombrePermiso) {
            return Roles.Any(rol => rol.Rol.CheckeaPermiso(nombrePermiso));
        }
    }
}
