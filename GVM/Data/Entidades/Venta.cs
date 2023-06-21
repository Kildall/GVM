using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Entidades
{
    [Table("Venta")]
    public class Venta
    {
        [Key]
        public int VentaId { get; set; }
        public int ClienteId { get; set; }
        public int Estado { get; set; } 
        public DateTime FechaInicio { get; set; }
        public DateTime FechaUltimaActualizacion { get; set; }

        public Cliente Cliente { get; set; }

        [ForeignKey("Estado")]
        public EstadoVenta EstadoVenta { get; set; }
        public ICollection<ProductoVenta> Productos { get; set; }
    }
}
