using GVM.Data.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.ViewModels
{
    public class CompraViewModel
    {
        public int CompraId { get; set; }
        public Empleado Empleado { get; set; } = new ();
        public Distribuidor Distribuidor { get; set; } = new ();
        public DateTime Fecha { get; set; } = new ();
        public double Monto { get; set; } = 0;
        public string Descripcion { get; set; } = string.Empty;
        public List<ProductoViewModel> Productos { get; set; } = new ();
    }
}
