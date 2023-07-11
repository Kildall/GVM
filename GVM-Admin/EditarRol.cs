using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using GVM_Admin.Security;
using GVM_Admin.Security.Entidades;

namespace GVM_Admin {
    public partial class EditarRol : Form {
        private readonly SeguridadContext _dbContext;
        private Rol _rol;
        public EditarRol(SeguridadContext dbContext, Rol rol) {
            _dbContext = dbContext;
            _rol = rol;
            InitializeComponent();
            tbNombre.Text = _rol.Nombre;
            dgvSistema.DataSource = _dbContext.Permisos.ToList();
            var permisosEnRol = new List<Entidad>();
            foreach (var entidad in _rol.Permisos) {
                permisosEnRol.AddRange(entidad.ListaPermiso(TipoEntidad.Permiso));
            }
            dgvPermisosRol.DataSource = permisosEnRol;
        }

        private void btnAgregar_Click(object sender, EventArgs e) {
            if (dgvSistema.CurrentRow != null) {
                var permiso = (Entidad)dgvSistema.CurrentRow.DataBoundItem;
                _rol.Permisos.Add(permiso);
                var permisosEnRol = new List<Entidad>();
                foreach (var entidad in _rol.Permisos) {
                    permisosEnRol.AddRange(entidad.ListaPermiso(TipoEntidad.Permiso));
                }
                dgvPermisosRol.DataSource = permisosEnRol;
            }
        }

        private void btnSacar_Click(object sender, EventArgs e) {
            if (dgvPermisosRol.CurrentRow != null) {
                var permiso = (Entidad)dgvPermisosRol.CurrentRow.DataBoundItem;
                var rp = _rol.Permisos.FirstOrDefault(permiso);
                if (rp == null) {
                    throw new Exception("Not found permiso");
                }
                _rol.Permisos.Remove(rp);
                var permisosEnRol = new List<Entidad>();
                foreach (var entidad in _rol.Permisos) {
                    permisosEnRol.AddRange(entidad.ListaPermiso(TipoEntidad.Permiso));
                }
                dgvPermisosRol.DataSource = permisosEnRol;
            }
        }

        private void tbNombre_TextChanged(object sender, EventArgs e) {
            tbNombre.Text = _rol.Nombre;
        }

        private void EditarRol_Load(object sender, EventArgs e) {

        }
    }
}
