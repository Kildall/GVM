using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.ViewModels {
    public class RepartidorViewModel {
        public int RepartidorId { get; set; }
        public string Nombre { get; set; }
        public string Telefono { get; set; }
        public virtual EnvioViewModel Envios { get; set; }
    }
}
