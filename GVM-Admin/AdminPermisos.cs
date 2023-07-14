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
    public partial class AdminPermisos : Form {
        private readonly SeguridadContext _dbContext;
        private readonly Usuario _usuario;
        public AdminPermisos(SeguridadContext dbContext, Usuario usuario) {
            _usuario = usuario;
            _dbContext = dbContext;
            InitializeComponent();
        }

        private void AdminPermisos_Load(object sender, EventArgs e) {
            ActualizarPermisos();
        }

        private void btnAgregar_Click(object sender, EventArgs e) {
            if (dgvPermisos.CurrentRow != null) {
                var permiso = (Entidad) dgvPermisos.CurrentRow.DataBoundItem;

                var permisosUsuario = new List<Entidad>();
                foreach (var entidad in _usuario.Permisos) {
                    permisosUsuario.AddRange(entidad.Entidad.ListaPermiso(TipoEntidad.Permiso));
                }

                var permisoExiste = _usuario.Permisos.FirstOrDefault(x => x.Entidad == permiso);
                if (permisoExiste != null) {
                    var result = MessageBox.Show("El permiso que quiere agregar ya existe, seguro lo quiere agregar?", "Seguro", MessageBoxButtons.YesNo);
                    if (result == DialogResult.Yes) {
                        AgregarPermiso(permiso);
                    }
                    return;
                }

                if (permisosUsuario.Contains(permiso)) {
                    var result =
                        MessageBox.Show(
                            "El permiso que quiere agregar ya fue agregado por un ROL, seguro quiere agregarlo?",
                            "Seguro", MessageBoxButtons.YesNo);
                    if (result == DialogResult.Yes) {
                        AgregarPermiso(permiso);
                    }
                    return;
                }

                AgregarPermiso(permiso);
            }
        }

        private void btnSacar_Click(object sender, EventArgs e) {
            if (dgvPermisosUsuario.CurrentRow != null) {
                var permiso = (Entidad)dgvPermisosUsuario.CurrentRow.DataBoundItem;
                var eu = _usuario.Permisos.FirstOrDefault(x => x.Entidad == permiso);
                if (eu == null) {
                    MessageBox.Show(@"No se puede eliminar un permiso que corresponde a un rol");
                } else {
                    _usuario.Permisos.Remove(eu);
                    ActualizarPermisos();
                }
            }
        }

        private void ActualizarPermisos() {
            var permisosUsuario = new List<Entidad>();
            foreach (var entidad in _usuario.Permisos) {
                permisosUsuario.AddRange(entidad.Entidad.ListaPermiso(TipoEntidad.Permiso));
            }

            var permisosSistema = _dbContext.Permisos.ToList();
            dgvPermisos.DataSource = permisosSistema;
            dgvPermisosUsuario.DataSource = permisosUsuario;
        }

        private void AgregarPermiso(Entidad permiso) {
            EntidadUsuario eu = new EntidadUsuario() {
                Entidad = permiso,
                Usuario = _usuario
            };
            _usuario.Permisos.Add(eu);
            ActualizarPermisos();
        }
    }
}
