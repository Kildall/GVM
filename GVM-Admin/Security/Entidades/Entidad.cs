namespace GVM_Admin.Security.Entidades {
    public abstract class Entidad {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public TipoEntidad Tipo { get; set; }

        protected Entidad(string nombre) {
            Nombre = nombre;
        }

        public abstract ICollection<Entidad> ListaPermiso(TipoEntidad? tipo);
        public abstract bool CheckeaPermiso(string nombre);
    }
}
