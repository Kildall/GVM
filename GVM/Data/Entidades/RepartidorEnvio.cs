using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace GVM.Data.Entidades
{
    [PrimaryKey(nameof(RepartidorId), nameof(EnvioId))]
    public class RepartidorEnvio
    {
        public int RepartidorId { get; set; }

        public int EnvioId { get; set; }

        public int Estado { get; set; }

        [ForeignKey("RepartidorId")]
        public Repartidor Repartidor { get; set; }

        [ForeignKey("EnvioId")]
        public Envio Envio { get; set; }

        [ForeignKey("Estado")]
        public EstadoEnvio EstadoEnvio { get; set; }
    }
}
