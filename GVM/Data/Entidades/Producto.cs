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
        [Key]
        public int IdProducto { get; set; }
        public string Nombre { get; set; }
        public int Cantidad { get; set; }
        public float Medida { get; set; }
        public string Marca { get; set; }
        public float Precio { get; set; }
        public float Alto { get; set; }
        public float Ancho { get; set; }
        public float Largo { get; set; }

        public virtual ICollection<Compra> Compras { get; set; }
    }
}
