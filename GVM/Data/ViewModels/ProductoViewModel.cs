﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.ViewModels {
    public class ProductoViewModel 
    {
        public int ProductoId { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public int Cantidad { get; set; }
        public double Medida { get; set; }
        public string Marca { get; set; } = string.Empty;
        public double Precio { get; set; }
    }
}