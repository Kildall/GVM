using GVM.Security;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
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

                dbContext.Entry(usuario)
                    .Collection(u => u.Roles)
                    .Load();
                dgvRoles.DataSource = null;
                dgvRoles.DataSource = usuario.Roles.Select(ur => ur.Rol).ToList();
            }
        }

        private void dgvRoles_SelectionChanged(object sender, EventArgs e) {
            if (dbContext != null && dgvUsuarios.CurrentRow != null) {
                var usuario = (Usuario)dgvUsuarios.CurrentRow.DataBoundItem;

                dbContext.Entry(usuario)
                    .Collection(r => r.Roles)
                    .Load();
                dgvPermisos.DataSource = null;
                var permisos = usuario.Roles
                    .SelectMany(ur => ur.Rol.Permisos
                        .Select(x => x.Permiso).ToList()
                    ).Distinct().ToList();
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