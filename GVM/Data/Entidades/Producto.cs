using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace GVM.Data.Entidades
{
    [Table("Producto")]
    public class Producto
    {
        public int ProductoId { get; set; }
        public string Nombre { get; set; }
        public int Cantidad { get; set; }
        public double Medida { get; set; }
        public string Marca { get; set; }
        public double Precio { get; set; }

        public ICollection<CompraProducto> Compras { get; set; }
        public ICollection<ProductoVenta> Ventas { get; set; }
    }
}
