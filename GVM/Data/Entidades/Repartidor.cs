using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Entidades
{
    [Table("Repartidor")]
    public class Repartidor
    {
        public int RepartidorId { get; set; }
        public string Nombre { get; set; }
        public string Telefono { get; set; }
        public virtual ICollection<RepartidorEnvio> Envios { get; set; }
    }
}
