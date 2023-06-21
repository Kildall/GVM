using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace GVM.Data.Entidades
{
    [PrimaryKey(nameof(CompraId), nameof(ProductoId))]
    public class CompraProducto
    {
        public int CompraId { get; set; }
        public int ProductoId { get; set; }
        public int Cantidad { get; set; }

        [ForeignKey("CompraId")]
        public Compra Compra { get; set; }

        [ForeignKey("ProductoId")]
        public Producto Producto { get; set; }
    }
}
