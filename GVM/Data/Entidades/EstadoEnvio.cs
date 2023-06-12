using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace GVM.Data.Entidades
{
    public class EstadoEnvio
    {
        [Key]
        public int IdEstado { get; set; }
        public string DescEstado { get; set; }
    }
}
