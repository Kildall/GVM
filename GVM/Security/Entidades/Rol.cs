namespace GVM.Security.Entidades {
    public class Rol : Entidad {
        public virtual ICollection<Entidad> Permisos { get; set; } = new List<Entidad>();

        public Rol(string nombre) : base(nombre) {
            Tipo = TipoEntidad.Rol;
        }
        public override bool CheckeaPermiso(string nombrePermiso) {
            return Permisos.Any(permiso => permiso.CheckeaPermiso(nombrePermiso));
        }
        public override ICollection<Entidad> ListaPermiso(TipoEntidad? tipo) {
            List<Entidad> permisos = new List<Entidad>();
            if (tipo == Tipo) {
                permisos.Add(this);
            }
            foreach (var entidad in Permisos) {
                permisos.AddRange(entidad.ListaPermiso(tipo));
            }
            return permisos;
        }
    }
}
