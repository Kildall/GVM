using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Entidades
{
    public class Direccion
    {
        [Key]
        public int IdDireccion { get; set; }
        public int IdCliente { get; set; }
        public string Calle1 { get; set; }
        public string Calle2 { get; set; }
        public string CodigoPostal { get; set; }
        public string Provincia { get; set; }
        public string Localidad { get; set; }
        public string Detalle { get; set; }

        public Cliente Cliente { get; set; }
    }
}
