namespace GVM_Admin.Security.Entidades {
    public abstract class EntidadSeguridad {
        public string Nombre { get; set; }

        protected EntidadSeguridad(string nombre) {
            Nombre = nombre;
        }

        public abstract bool CheckeaPermiso(string nombrePermiso);
    }
}
