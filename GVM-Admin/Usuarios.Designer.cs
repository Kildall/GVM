namespace GVM_Admin {
    partial class Usuarios {
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            components = new System.ComponentModel.Container();
            btnGuardarCambios = new Button();
            gbPermisos = new GroupBox();
            btnAdminPermiso = new Button();
            gbRoles = new GroupBox();
            btnEditarRol = new Button();
            btnAdminRol = new Button();
            label3 = new Label();
            label2 = new Label();
            label1 = new Label();
            dgvPermisos = new DataGridView();
            nombreDataGridViewTextBoxColumn2 = new DataGridViewTextBoxColumn();
            permisoBindingSource = new BindingSource(components);
            dgvRoles = new DataGridView();
            nombreDataGridViewTextBoxColumn1 = new DataGridViewTextBoxColumn();
            rolBindingSource = new BindingSource(components);
            dgvUsuarios = new DataGridView();
            nombreDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            emailDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            claveDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            habilitadoDataGridViewCheckBoxColumn = new DataGridViewCheckBoxColumn();
            usuarioBindingSource = new BindingSource(components);
            gbPermisos.SuspendLayout();
            gbRoles.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvPermisos).BeginInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvRoles).BeginInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvUsuarios).BeginInit();
            ((System.ComponentModel.ISupportInitialize)usuarioBindingSource).BeginInit();
            SuspendLayout();
            // 
            // btnGuardarCambios
            // 
            btnGuardarCambios.Location = new Point(23, 516);
            btnGuardarCambios.Name = "btnGuardarCambios";
            btnGuardarCambios.Size = new Size(116, 23);
            btnGuardarCambios.TabIndex = 29;
            btnGuardarCambios.Text = "Guardar cambios";
            btnGuardarCambios.UseVisualStyleBackColor = true;
            btnGuardarCambios.Click += btnGuardarCambios_Click;
            // 
            // gbPermisos
            // 
            gbPermisos.Controls.Add(btnAdminPermiso);
            gbPermisos.Location = new Point(623, 465);
            gbPermisos.Name = "gbPermisos";
            gbPermisos.Size = new Size(144, 100);
            gbPermisos.TabIndex = 28;
            gbPermisos.TabStop = false;
            gbPermisos.Text = "Permisos";
            // 
            // btnAdminPermiso
            // 
            btnAdminPermiso.Location = new Point(6, 37);
            btnAdminPermiso.Name = "btnAdminPermiso";
            btnAdminPermiso.Size = new Size(132, 23);
            btnAdminPermiso.TabIndex = 0;
            btnAdminPermiso.Text = "Administrar Permisos";
            btnAdminPermiso.UseVisualStyleBackColor = true;
            btnAdminPermiso.Click += btnAdminPermiso_Click;
            // 
            // gbRoles
            // 
            gbRoles.Controls.Add(btnEditarRol);
            gbRoles.Controls.Add(btnAdminRol);
            gbRoles.Location = new Point(473, 465);
            gbRoles.Name = "gbRoles";
            gbRoles.Size = new Size(144, 100);
            gbRoles.TabIndex = 27;
            gbRoles.TabStop = false;
            gbRoles.Text = "Roles";
            // 
            // btnEditarRol
            // 
            btnEditarRol.Location = new Point(6, 51);
            btnEditarRol.Name = "btnEditarRol";
            btnEditarRol.Size = new Size(132, 23);
            btnEditarRol.TabIndex = 1;
            btnEditarRol.Text = "Editar Rol";
            btnEditarRol.UseVisualStyleBackColor = true;
            btnEditarRol.Click += btnEditarRol_Click;
            // 
            // btnAdminRol
            // 
            btnAdminRol.Location = new Point(6, 22);
            btnAdminRol.Name = "btnAdminRol";
            btnAdminRol.Size = new Size(132, 23);
            btnAdminRol.TabIndex = 0;
            btnAdminRol.Text = "Administrar Roles";
            btnAdminRol.UseVisualStyleBackColor = true;
            btnAdminRol.Click += btnAdminRoles_Click;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(664, 12);
            label3.Name = "label3";
            label3.Size = new Size(55, 15);
            label3.TabIndex = 26;
            label3.Text = "Permisos";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(526, 12);
            label2.Name = "label2";
            label2.Size = new Size(35, 15);
            label2.TabIndex = 25;
            label2.Text = "Roles";
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(223, 12);
            label1.Name = "label1";
            label1.Size = new Size(52, 15);
            label1.TabIndex = 24;
            label1.Text = "Usuarios";
            // 
            // dgvPermisos
            // 
            dgvPermisos.AutoGenerateColumns = false;
            dgvPermisos.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvPermisos.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn2 });
            dgvPermisos.DataSource = permisoBindingSource;
            dgvPermisos.Location = new Point(623, 33);
            dgvPermisos.Name = "dgvPermisos";
            dgvPermisos.RowTemplate.Height = 25;
            dgvPermisos.Size = new Size(144, 426);
            dgvPermisos.TabIndex = 23;
            // 
            // nombreDataGridViewTextBoxColumn2
            // 
            nombreDataGridViewTextBoxColumn2.DataPropertyName = "Nombre";
            nombreDataGridViewTextBoxColumn2.HeaderText = "Nombre";
            nombreDataGridViewTextBoxColumn2.Name = "nombreDataGridViewTextBoxColumn2";
            // 
            // permisoBindingSource
            // 
            permisoBindingSource.DataSource = typeof(Security.Entidades.Permiso);
            // 
            // dgvRoles
            // 
            dgvRoles.AutoGenerateColumns = false;
            dgvRoles.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvRoles.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn1 });
            dgvRoles.DataSource = rolBindingSource;
            dgvRoles.Location = new Point(473, 33);
            dgvRoles.Name = "dgvRoles";
            dgvRoles.RowTemplate.Height = 25;
            dgvRoles.Size = new Size(144, 426);
            dgvRoles.TabIndex = 22;
            dgvRoles.SelectionChanged += dgvRoles_SelectionChanged;
            // 
            // nombreDataGridViewTextBoxColumn1
            // 
            nombreDataGridViewTextBoxColumn1.DataPropertyName = "Nombre";
            nombreDataGridViewTextBoxColumn1.HeaderText = "Nombre";
            nombreDataGridViewTextBoxColumn1.Name = "nombreDataGridViewTextBoxColumn1";
            // 
            // rolBindingSource
            // 
            rolBindingSource.DataSource = typeof(Security.Entidades.Rol);
            // 
            // dgvUsuarios
            // 
            dgvUsuarios.AutoGenerateColumns = false;
            dgvUsuarios.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvUsuarios.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn, emailDataGridViewTextBoxColumn, claveDataGridViewTextBoxColumn, habilitadoDataGridViewCheckBoxColumn });
            dgvUsuarios.DataSource = usuarioBindingSource;
            dgvUsuarios.Location = new Point(23, 33);
            dgvUsuarios.Name = "dgvUsuarios";
            dgvUsuarios.RowTemplate.Height = 25;
            dgvUsuarios.Size = new Size(444, 426);
            dgvUsuarios.TabIndex = 21;
            dgvUsuarios.SelectionChanged += DgvUsuariosSelectionChanged;
            // 
            // nombreDataGridViewTextBoxColumn
            // 
            nombreDataGridViewTextBoxColumn.DataPropertyName = "Nombre";
            nombreDataGridViewTextBoxColumn.HeaderText = "Nombre";
            nombreDataGridViewTextBoxColumn.Name = "nombreDataGridViewTextBoxColumn";
            // 
            // emailDataGridViewTextBoxColumn
            // 
            emailDataGridViewTextBoxColumn.DataPropertyName = "Email";
            emailDataGridViewTextBoxColumn.HeaderText = "Email";
            emailDataGridViewTextBoxColumn.Name = "emailDataGridViewTextBoxColumn";
            // 
            // claveDataGridViewTextBoxColumn
            // 
            claveDataGridViewTextBoxColumn.DataPropertyName = "Clave";
            claveDataGridViewTextBoxColumn.HeaderText = "Clave";
            claveDataGridViewTextBoxColumn.Name = "claveDataGridViewTextBoxColumn";
            // 
            // habilitadoDataGridViewCheckBoxColumn
            // 
            habilitadoDataGridViewCheckBoxColumn.DataPropertyName = "Habilitado";
            habilitadoDataGridViewCheckBoxColumn.HeaderText = "Habilitado";
            habilitadoDataGridViewCheckBoxColumn.Name = "habilitadoDataGridViewCheckBoxColumn";
            // 
            // usuarioBindingSource
            // 
            usuarioBindingSource.DataSource = typeof(Security.Entidades.Usuario);
            // 
            // Usuarios
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            Controls.Add(btnGuardarCambios);
            Controls.Add(gbPermisos);
            Controls.Add(gbRoles);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(dgvPermisos);
            Controls.Add(dgvRoles);
            Controls.Add(dgvUsuarios);
            Name = "Usuarios";
            Size = new Size(791, 583);
            Load += Usuarios_Load;
            gbPermisos.ResumeLayout(false);
            gbRoles.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvPermisos).EndInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvRoles).EndInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvUsuarios).EndInit();
            ((System.ComponentModel.ISupportInitialize)usuarioBindingSource).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button btnGuardarCambios;
        private GroupBox gbPermisos;
        private Button btnAdminPermiso;
        private GroupBox gbRoles;
        private Button btnEditarRol;
        private Button btnAdminRol;
        private Label label3;
        private Label label2;
        private Label label1;
        private DataGridView dgvPermisos;
        private DataGridView dgvRoles;
        private DataGridView dgvUsuarios;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn2;
        private BindingSource permisoBindingSource;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn1;
        private BindingSource rolBindingSource;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn;
        private DataGridViewTextBoxColumn emailDataGridViewTextBoxColumn;
        private DataGridViewTextBoxColumn claveDataGridViewTextBoxColumn;
        private DataGridViewCheckBoxColumn habilitadoDataGridViewCheckBoxColumn;
        private BindingSource usuarioBindingSource;
    }
}
