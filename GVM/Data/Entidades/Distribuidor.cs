using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace GVM.Data.Entidades
{
    [Table("Distribuidor")]
    public class Distribuidor
    {
        public int DistribuidorId { get; set; }
        public string Nombre { get; set; }
    }
}
