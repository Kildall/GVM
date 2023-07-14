namespace GVM_Admin {
    partial class AdminPermisos {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            components = new System.ComponentModel.Container();
            dgvPermisos = new DataGridView();
            nombreDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            permisoBindingSource = new BindingSource(components);
            btnSacar = new Button();
            btnAgregar = new Button();
            dgvPermisosUsuario = new DataGridView();
            dataGridViewTextBoxColumn1 = new DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)dgvPermisos).BeginInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvPermisosUsuario).BeginInit();
            SuspendLayout();
            // 
            // dgvPermisos
            // 
            dgvPermisos.AutoGenerateColumns = false;
            dgvPermisos.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvPermisos.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn });
            dgvPermisos.DataSource = permisoBindingSource;
            dgvPermisos.Location = new Point(12, 12);
            dgvPermisos.Name = "dgvPermisos";
            dgvPermisos.RowHeadersWidthSizeMode = DataGridViewRowHeadersWidthSizeMode.AutoSizeToAllHeaders;
            dgvPermisos.RowTemplate.Height = 25;
            dgvPermisos.Size = new Size(124, 426);
            dgvPermisos.TabIndex = 0;
            // 
            // nombreDataGridViewTextBoxColumn
            // 
            nombreDataGridViewTextBoxColumn.DataPropertyName = "Nombre";
            nombreDataGridViewTextBoxColumn.HeaderText = "Nombre";
            nombreDataGridViewTextBoxColumn.Name = "nombreDataGridViewTextBoxColumn";
            // 
            // permisoBindingSource
            // 
            permisoBindingSource.DataSource = typeof(Security.Entidades.Permiso);
            // 
            // btnSacar
            // 
            btnSacar.Location = new Point(165, 221);
            btnSacar.Name = "btnSacar";
            btnSacar.Size = new Size(75, 23);
            btnSacar.TabIndex = 7;
            btnSacar.Text = "<-";
            btnSacar.UseVisualStyleBackColor = true;
            btnSacar.Click += btnSacar_Click;
            // 
            // btnAgregar
            // 
            btnAgregar.Location = new Point(165, 192);
            btnAgregar.Name = "btnAgregar";
            btnAgregar.Size = new Size(75, 23);
            btnAgregar.TabIndex = 6;
            btnAgregar.Text = "->";
            btnAgregar.UseVisualStyleBackColor = true;
            btnAgregar.Click += btnAgregar_Click;
            // 
            // dgvPermisosUsuario
            // 
            dgvPermisosUsuario.AutoGenerateColumns = false;
            dgvPermisosUsuario.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvPermisosUsuario.Columns.AddRange(new DataGridViewColumn[] { dataGridViewTextBoxColumn1 });
            dgvPermisosUsuario.DataSource = permisoBindingSource;
            dgvPermisosUsuario.Location = new Point(267, 12);
            dgvPermisosUsuario.Name = "dgvPermisosUsuario";
            dgvPermisosUsuario.RowHeadersWidthSizeMode = DataGridViewRowHeadersWidthSizeMode.AutoSizeToAllHeaders;
            dgvPermisosUsuario.RowTemplate.Height = 25;
            dgvPermisosUsuario.Size = new Size(124, 426);
            dgvPermisosUsuario.TabIndex = 8;
            // 
            // dataGridViewTextBoxColumn1
            // 
            dataGridViewTextBoxColumn1.DataPropertyName = "Nombre";
            dataGridViewTextBoxColumn1.HeaderText = "Nombre";
            dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
            // 
            // AdminPermisos
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(402, 450);
            Controls.Add(dgvPermisosUsuario);
            Controls.Add(btnSacar);
            Controls.Add(btnAgregar);
            Controls.Add(dgvPermisos);
            Name = "AdminPermisos";
            Text = "AdminPermisos";
            Load += AdminPermisos_Load;
            ((System.ComponentModel.ISupportInitialize)dgvPermisos).EndInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvPermisosUsuario).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private DataGridView dgvPermisos;
        private BindingSource permisoBindingSource;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn;
        private Button btnSacar;
        private Button btnAgregar;
        private DataGridView dgvPermisosUsuario;
        private DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
    }
}