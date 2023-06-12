using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Entidades
{
    public class Repartidor
    {
        [Key]
        public int IdRepartidor { get; set; }
        public string Nombre { get; set; }
        public string Telefono { get; set; }

        public ICollection<Envio> Envios { get; set; }
    }
}
