using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace GVM.Data.Entidades
{
    [Table("Envio")]
    public class Envio
    {
        public int EnvioId { get; set; }
        public int VentaId { get; set; }
        public int RepartidorId { get; set; }
        public int DireccionId { get; set; }
        public int Estado { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaUltimaActualizacion { get; set; }

        public virtual Venta Venta { get; set; }
        public virtual Repartidor Repartidor { get; set; }
        public virtual Direccion Direccion { get; set; }

        [ForeignKey("Estado")]
        public virtual EstadoEnvio EstadoEnvio { get; set; }
    }
}
