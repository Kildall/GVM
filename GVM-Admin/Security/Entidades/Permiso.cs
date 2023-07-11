namespace GVM_Admin.Security.Entidades {
    public class Permiso : Entidad {
        public Permiso(string nombre) : base(nombre) {
            Tipo = TipoEntidad.Permiso;
        }
        public override bool CheckeaPermiso(string nombrePermiso) {
            return Nombre == nombrePermiso;
        }

        public override ICollection<Entidad> ListaPermiso(TipoEntidad? tipo) {
            if (tipo != TipoEntidad.Permiso) {
                return new List<Entidad>();
            }
            return new List<Entidad> { this };
        }
    }
}
