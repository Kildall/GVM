using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace GVM.Data.Entidades
{
    [Table("Empleado")]
    public class Empleado
    {
        [Key]
        public string IdEmpleado { get; set; }
        public string Nombre { get; set; }
        public string Cargo { get; set; }
    }
}
