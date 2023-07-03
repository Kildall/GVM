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
        public Empleado Empleado { get; set; }
        public Distribuidor Distribuidor { get; set; }
        public DateTime Fecha { get; set; }
        public double Monto { get; set; }
        public string Descripcion { get; set; }
        public List<ProductoViewModel> Productos { get; set; }
    }
}
