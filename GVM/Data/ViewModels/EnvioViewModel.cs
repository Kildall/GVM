

namespace GVM.Data.ViewModels {
    public class EnvioViewModel {
        public int EnvioId { get; set; }
        public int VentaId { get; set; }
        public int RepartidorId { get; set; }
        public int DireccionId { get; set; }
        public int Estado { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaUltimaActualizacion { get; set; }

        public virtual VentaViewModel Venta { get; set; }
        public virtual RepartidorViewModel Repartidor { get; set; }
        public virtual DireccionViewModel Direccion { get; set; }
        public virtual EstadoEnvioViewModel EstadoEnvio { get; set; }
    }
}
