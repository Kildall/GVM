using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace GVM.Data.Entidades
{
    public class Distribuidor
    {
        [Key]
        public int IdDistribuidor { get; set; }
        public string Nombre { get; set; }
    }
}
