using GVM.Data.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.DTOs
{
    public class CompraViewModel
    {
        public int compraId { get; set; }
        public Empleado empleado { get; set; }
        public Distribuidor distribuidor { get; set; }
        public DateTime fecha { get; set; }
        public double monto { get; set; }
        public string descripcion { get; set; }
    }
}
