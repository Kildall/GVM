using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.ViewModels {
    public class VentaViewModel {
        public int VentaId { get; set; }
        public int ClienteId { get; set; }
        public EstadoVentaViewModel Estado { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaUltimaActualizacion { get; set; }
        public ClienteViewModel Cliente { get; set; }
        public List<ProductoViewModel> Productos { get; set; } = new();
    }
}
