using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace GVM.Data.Entidades
{
    [Table("EstadoVenta")]
    public class EstadoVenta
    {
        [Key]
        public int EstadoId { get; set; }
        public string DescEstado{ get; set; }
    }
}
