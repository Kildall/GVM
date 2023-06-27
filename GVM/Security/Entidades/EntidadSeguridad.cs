using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Security.Entidades {
    public abstract class EntidadSeguridad {
        public string Nombre { get; set; }

        protected EntidadSeguridad(string nombre) {
            Nombre = nombre;
        }

        public abstract bool CheckeaPermiso(string nombrePermiso);
    }
}
