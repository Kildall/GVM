using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Resources;
using System.Reflection;
using GVM.Data.Entidades;
using Microsoft.EntityFrameworkCore.SqlServer;

namespace GVM.Data
{
    public class GVMContext : DbContext
    {
        public GVMContext(DbContextOptions<GVMContext> options) : base(options)
        {

        }

        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Compra> Compras { get; set; }
        public DbSet<Direccion> Direcciones { get; set; }
        public DbSet<Distribuidor> Distribuidores { get; set; }
        public DbSet<Empleado> Empleados { get; set; }
        public DbSet<Envio> Envios { get; set; }
        public DbSet<EstadoEnvio> Estados { get; set; }
        public DbSet<EstadoVenta> EstadosVentas { get; set; }
        public DbSet<Producto> Productos { get; set; }
        public DbSet<Repartidor> Repartidores { get; set; }
        public DbSet<Venta> Ventas { get; set; }

    }
}
