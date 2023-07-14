using Microsoft.EntityFrameworkCore;
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
    public partial class Usuarios : UserControl {
        private readonly SeguridadContext _dbContext;
        public Usuarios(SeguridadContext dbContext) {
            _dbContext = dbContext;
            InitializeComponent();
        }

        private void DgvUsuariosSelectionChanged(object sender, EventArgs e) {
            if (dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;

                var roles = new List<Entidad>();
                foreach (var entidad in usuario.Permisos) {
                    roles.AddRange(entidad.Entidad.ListaPermiso(TipoEntidad.Rol));
                }

                dgvRoles.DataSource = roles;
            }
        }

        private void dgvRoles_SelectionChanged(object sender, EventArgs e) {
            if (dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;

                var permisos = new List<Entidad>();
                foreach (var entidad in usuario.Permisos) {
                    permisos.AddRange(entidad.Entidad.ListaPermiso(TipoEntidad.Permiso));
                }

                dgvPermisos.DataSource = permisos;
            }
        }

        private void btnGuardarCambios_Click(object sender, EventArgs e) {
            _dbContext!.SaveChanges();

            dgvUsuarios.Refresh();
            dgvRoles.Refresh();
            dgvPermisos.Refresh();
        }

        private void btnAdminRoles_Click(object sender, EventArgs e) {
            if (dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;
                AdminRoles form = new AdminRoles(_dbContext, usuario);
                Hide();
                form.FormClosing += (o, args) => { this.Show(); };
                form.Show();
            }
        }

        private void btnEditarRol_Click(object sender, EventArgs e) {
            if (dgvRoles.CurrentRow != null) {
                var rol = (Rol)dgvRoles.CurrentRow.DataBoundItem;
                EditarRol form = new EditarRol(_dbContext, rol);
                Hide();
                form.FormClosing += (o, args) => { this.Show(); };
                form.Show();
            }
        }

        private void btnAdminPermiso_Click(object sender, EventArgs e) {
            if (dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;
                AdminPermisos form = new AdminPermisos(_dbContext, usuario);
                Hide();
                form.FormClosing += (o, args) => { this.Show(); };
                form.Show();
            }
        }

        private void Usuarios_Load(object sender, EventArgs e) {
            usuarioBindingSource.DataSource = new BindingList<Usuario>(_dbContext.Usuarios.ToList());
        }
    }
}
