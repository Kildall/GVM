using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace GVM.Data.Entidades
{
    public class Envio
    {
        [Key]
        public int IdEnvio { get; set; }
        public int IdRepartidor { get; set; }
        public int IdDireccion { get; set; }
        public int IdEstado { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaUltimaActualizacion { get; set; }

        public Venta Venta { get; set; }
        public Repartidor Repartidor { get; set; }
        public Direccion Direccion { get; set; }
        public EstadoEnvio EstadoEnvio { get; set; }
    }
}
