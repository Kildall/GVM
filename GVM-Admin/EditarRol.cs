using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using GVM.Security;
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
            dgvRol.DataSource = _rol.Permisos.Select(rp => rp.Permiso).ToList();
        }

        private void btnAgregar_Click(object sender, EventArgs e) {
            if (dgvSistema.CurrentRow != null) {
                var permiso = (Permiso)dgvSistema.CurrentRow.DataBoundItem;
                var ur = new RolPermiso() {
                    Rol = _rol,
                    Permiso = permiso
                };
                _rol.Permisos.Add(ur);
                dgvRol.DataSource = _rol.Permisos.Select(rp => rp.Permiso).ToList();
            }
        }

        private void btnSacar_Click(object sender, EventArgs e) {
            if (dgvRol.CurrentRow != null) {
                var permiso = (Permiso)dgvRol.CurrentRow.DataBoundItem;
                var rp = _rol.Permisos.FirstOrDefault(x => x.Permiso == permiso);
                if (rp == null) {
                    throw new Exception("Not found permiso");
                }
                _rol.Permisos.Remove(rp);
                dgvRol.DataSource = _rol.Permisos.Select(x => x.Permiso).ToList();
            }
        }

        private void tbNombre_TextChanged(object sender, EventArgs e) {
            tbNombre.Text = _rol.Nombre;
        }
    }
}
