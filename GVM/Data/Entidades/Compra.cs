using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Entidades
{
    [Table("Compra")]
    public class Compra
    {
        public int CompraId { get; set; }
        public int EmpleadoId { get; set; }
        public int DistribuidorId { get; set; }
        public DateTime Fecha { get; set; }
        public double Monto { get; set; }
        public string Descripcion { get; set; }

        public Empleado Empleado { get; set; }
        public Distribuidor Distribuidor { get; set; }
        public ICollection<CompraProducto> Productos { get; set; }
    }
}
