using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using GVM_Admin.Security;
using GVM_Admin.Security.Entidades;

namespace GVM_Admin {
    public partial class Form1 : Form {
        private SeguridadContext? dbContext;
        public Form1() {
            dbContext = new SeguridadContext();
            InitializeComponent();
        }

        protected override void OnClosing(CancelEventArgs e) {
            base.OnClosing(e);
            panel1.Controls.Clear();
            dbContext?.Dispose();
            dbContext = null;
        }

        private void usuariosToolStripMenuItem_Click(object sender, EventArgs e) {
            if (dbContext == null) return;
            panel1.Controls.Add(new Usuarios(dbContext));
        }
    }
}