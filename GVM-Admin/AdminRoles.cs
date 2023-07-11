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
using Microsoft.EntityFrameworkCore;

namespace GVM_Admin {
    public partial class AdminRoles : Form {
        private readonly SeguridadContext _dbContext;
        private Usuario _usuario;
        public AdminRoles(SeguridadContext dbContext, Usuario usuario) {
            _dbContext = dbContext;
            _usuario = usuario;
            InitializeComponent();
        }

        private void AgregarRol_Load(object sender, EventArgs e) {
            dgvSistema.DataSource = _dbContext.Roles.ToList();
            dgvUsuario.DataSource = _usuario.Permisos.Select(x => x.Entidad).ToList();
        }

        private void btnAgregar_Click(object sender, EventArgs e) {
            if (dgvSistema.CurrentRow != null) {
                var entidad = (Entidad)dgvSistema.CurrentRow.DataBoundItem;
                var eu = new EntidadUsuario() {
                    Entidad = entidad,
                    Usuario = _usuario
                };
                _usuario.Permisos.Add(eu);
                dgvUsuario.DataSource = _usuario.Permisos
                    .Where(e => e.Entidad.Tipo == TipoEntidad.Rol)
                    .Select(x => (Rol)x.Entidad).ToList();
            }
        }

        private void btnSacar_Click(object sender, EventArgs e) {
            if (dgvUsuario.CurrentRow != null) {
                var entidad = (Entidad)dgvUsuario.CurrentRow.DataBoundItem;
                var ur = _usuario.Permisos.FirstOrDefault(x => x.Entidad == entidad);
                if (ur == null) {
                    throw new Exception("Not found rol");
                }
                _usuario.Permisos.Remove(ur);
                dgvUsuario.DataSource = _usuario.Permisos
                    .Where(e => e.Entidad.Tipo == TipoEntidad.Rol)
                    .Select(x => (Rol)x.Entidad).ToList();
            }
        }
    }
}
