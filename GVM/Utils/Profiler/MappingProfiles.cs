using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using GVM.Data.Entidades;
using GVM.Data.ViewModels;

namespace GVM.Utils.Profiler {
    public class MappingProfiles: Profile {
        public MappingProfiles() {
            CreateMap<Venta, VentaViewModel>()
                .ForMember(d => d.Estado, o => o.MapFrom(v => v.EstadoVenta))
                .ForMember(d => d.Productos, o => o.MapFrom(v => v.Productos.Select(p => p.Producto).ToList()));
            
            CreateMap<Compra, CompraViewModel>()
                .ForMember(d => d.Productos, o => o.MapFrom(c => c.Productos.Select(p => p.Producto).ToList()));
            CreateMap<EstadoVenta, EstadoVentaViewModel>();
            CreateMap<Empleado, EmpleadoViewModel>();
            CreateMap<Distribuidor, DistribuidorViewModel>();
            CreateMap<Producto, ProductoViewModel>();
            CreateMap<Cliente, ClienteViewModel>();
        }
    }
}
