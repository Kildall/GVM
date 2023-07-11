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
            dgvUsuario.DataSource = _usuario.Roles.Select(x => x.Rol).ToList();
        }

        private void btnAgregar_Click(object sender, EventArgs e) {
            if (dgvSistema.CurrentRow != null) {
                var rol = (Rol)dgvSistema.CurrentRow.DataBoundItem;
                var ur = new UsuarioRol() {
                    Rol = rol,
                    Usuario = _usuario
                };
                _usuario.Roles.Add(ur);
                dgvUsuario.DataSource = _usuario.Roles.Select(x => x.Rol).ToList();
            }
        }

        private void btnSacar_Click(object sender, EventArgs e) {
            if (dgvUsuario.CurrentRow != null) {
                var rol = (Rol)dgvUsuario.CurrentRow.DataBoundItem;
                var ur = _usuario.Roles.FirstOrDefault(x => x.Rol == rol);
                if (ur == null) {
                    throw new Exception("Not found rol");
                }
                _usuario.Roles.Remove(ur);
                dgvUsuario.DataSource = _usuario.Roles.Select(x => x.Rol).ToList();
            }
        }
    }
}
