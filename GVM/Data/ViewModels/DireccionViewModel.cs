using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.ViewModels {
    public class DireccionViewModel {
        public int DireccionId { get; set; }
        public int ClienteId { get; set; }
        public string Calle1 { get; set; }
        public string Calle2 { get; set; }
        public string CodigoPostal { get; set; }
        public string Provincia { get; set; }
        public string Localidad { get; set; }
        public string Detalle { get; set; }

        public virtual ClienteViewModel Cliente { get; set; }
    }
}
