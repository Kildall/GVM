using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Entidades
{
    public class Compra
    {
        [Key]
        public int IdCompra { get; set; }
        public int IdEmpleado { get; set; }
        public int IdDistribuidor { get; set; }
        public DateTime Fecha { get; set; }
        public DateTime Hora { get; set; }
        public float Monto { get; set; }
        public string Descripcion { get; set; }

        public Empleado Empleado { get; set; }
        public Distribuidor Distribuidor { get; set; }
        public virtual ICollection<Producto> Productos { get; set; }
    }
}
