using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using GVM_Admin.Security;
using GVM_Admin.Security.Entidades;

namespace GVM_Admin {
    public partial class Form1 : Form {
        private SeguridadContext? dbContext;
        public Form1() {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e) {
            dbContext = new SeguridadContext();

            usuarioBindingSource.DataSource = new BindingList<Usuario>(dbContext.Usuarios.ToList());
        }

        protected override void OnClosing(CancelEventArgs e) {
            base.OnClosing(e);

            dbContext?.Dispose();
            dbContext = null;
        }

        private void DgvUsuariosSelectionChanged(object sender, EventArgs e) {
            if (dbContext != null && dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;

                var roles = new List<Entidad>();
                foreach (var entidad in usuario.Permisos) {
                    roles.AddRange(entidad.Entidad.ListaPermiso(TipoEntidad.Rol));
                }

                dgvRoles.DataSource = roles;
            }
        }

        private void dgvRoles_SelectionChanged(object sender, EventArgs e) {
            if (dbContext != null && dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;

                var permisos = new List<Entidad>();
                foreach (var entidad in usuario.Permisos) {
                    permisos.AddRange(entidad.Entidad.ListaPermiso(TipoEntidad.Permiso));
                }

                dgvPermisos.DataSource = permisos;
            }
        }

        private void btnGuardarCambios_Click(object sender, EventArgs e) {
            dbContext!.SaveChanges();

            dgvUsuarios.Refresh();
            dgvRoles.Refresh();
            dgvPermisos.Refresh();
        }

        private void btnAdminRoles_Click(object sender, EventArgs e) {
            if (dbContext != null && dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;
                AdminRoles form = new AdminRoles(dbContext, usuario);
                Hide();
                form.FormClosing += (o, args) => { this.Show(); };
                form.Show();
            }
        }

        private void btnEditarRol_Click(object sender, EventArgs e) {
            if (dbContext != null && dgvRoles.CurrentRow != null) {
                var rol = (Rol)dgvRoles.CurrentRow.DataBoundItem;
                EditarRol form = new EditarRol(dbContext, rol);
                Hide();
                form.FormClosing += (o, args) => { this.Show(); };
                form.Show();
            }
        }
    }
}