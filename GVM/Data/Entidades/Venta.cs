using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Entidades
{
    public class Venta
    {
        [Key]
        public int IdVenta { get; set; }
        public int IdCliente { get; set; }
        public int IdEstado { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaUltimaActualizacion { get; set; }

        public Cliente Cliente { get; set; }
        public EstadoVenta EstadoVenta { get; set; }
        public ICollection<Producto> Productos { get; set; }
        public Envio? Envio { get; set; }
    }
}
