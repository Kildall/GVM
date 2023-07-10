namespace GVM_Admin {
    partial class Form1 {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
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
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            components = new System.ComponentModel.Container();
            dgvUsuarios = new DataGridView();
            usuarioIdDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            nombreDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            emailDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            habilitadoDataGridViewCheckBoxColumn = new DataGridViewCheckBoxColumn();
            usuarioBindingSource = new BindingSource(components);
            rolBindingSource = new BindingSource(components);
            dgvRoles = new DataGridView();
            dataGridViewTextBoxColumn2 = new DataGridViewTextBoxColumn();
            dgvPermisos = new DataGridView();
            dataGridViewTextBoxColumn5 = new DataGridViewTextBoxColumn();
            permisoBindingSource = new BindingSource(components);
            label1 = new Label();
            label2 = new Label();
            label3 = new Label();
            gbRoles = new GroupBox();
            btnEliminarRol = new Button();
            btnAgregarRol = new Button();
            gbPermisos = new GroupBox();
            btnEliminarPermiso = new Button();
            btnAgregarPermiso = new Button();
            btnGuardarCambios = new Button();
            ((System.ComponentModel.ISupportInitialize)dgvUsuarios).BeginInit();
            ((System.ComponentModel.ISupportInitialize)usuarioBindingSource).BeginInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvRoles).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvPermisos).BeginInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).BeginInit();
            gbRoles.SuspendLayout();
            gbPermisos.SuspendLayout();
            SuspendLayout();
            // 
            // dgvUsuarios
            // 
            dgvUsuarios.AutoGenerateColumns = false;
            dgvUsuarios.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvUsuarios.Columns.AddRange(new DataGridViewColumn[] { usuarioIdDataGridViewTextBoxColumn, nombreDataGridViewTextBoxColumn, emailDataGridViewTextBoxColumn, habilitadoDataGridViewCheckBoxColumn });
            dgvUsuarios.DataSource = usuarioBindingSource;
            dgvUsuarios.Location = new Point(12, 30);
            dgvUsuarios.Name = "dgvUsuarios";
            dgvUsuarios.RowTemplate.Height = 25;
            dgvUsuarios.Size = new Size(444, 426);
            dgvUsuarios.TabIndex = 12;
            dgvUsuarios.SelectionChanged += DgvUsuariosSelectionChanged;
            // 
            // usuarioIdDataGridViewTextBoxColumn
            // 
            usuarioIdDataGridViewTextBoxColumn.DataPropertyName = "UsuarioId";
            usuarioIdDataGridViewTextBoxColumn.HeaderText = "UsuarioId";
            usuarioIdDataGridViewTextBoxColumn.Name = "usuarioIdDataGridViewTextBoxColumn";
            usuarioIdDataGridViewTextBoxColumn.ReadOnly = true;
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
            // rolBindingSource
            // 
            rolBindingSource.DataSource = typeof(Security.Entidades.Rol);
            // 
            // dgvRoles
            // 
            dgvRoles.AutoGenerateColumns = false;
            dgvRoles.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvRoles.Columns.AddRange(new DataGridViewColumn[] { dataGridViewTextBoxColumn2 });
            dgvRoles.DataSource = rolBindingSource;
            dgvRoles.Location = new Point(462, 30);
            dgvRoles.Name = "dgvRoles";
            dgvRoles.RowTemplate.Height = 25;
            dgvRoles.Size = new Size(144, 426);
            dgvRoles.TabIndex = 13;
            dgvRoles.SelectionChanged += dgvRoles_SelectionChanged;
            // 
            // dataGridViewTextBoxColumn2
            // 
            dataGridViewTextBoxColumn2.DataPropertyName = "Nombre";
            dataGridViewTextBoxColumn2.HeaderText = "Nombre";
            dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            // 
            // dgvPermisos
            // 
            dgvPermisos.AutoGenerateColumns = false;
            dgvPermisos.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvPermisos.Columns.AddRange(new DataGridViewColumn[] { dataGridViewTextBoxColumn5 });
            dgvPermisos.DataSource = permisoBindingSource;
            dgvPermisos.Location = new Point(612, 30);
            dgvPermisos.Name = "dgvPermisos";
            dgvPermisos.RowTemplate.Height = 25;
            dgvPermisos.Size = new Size(144, 426);
            dgvPermisos.TabIndex = 14;
            // 
            // dataGridViewTextBoxColumn5
            // 
            dataGridViewTextBoxColumn5.DataPropertyName = "Nombre";
            dataGridViewTextBoxColumn5.HeaderText = "Nombre";
            dataGridViewTextBoxColumn5.Name = "dataGridViewTextBoxColumn5";
            // 
            // permisoBindingSource
            // 
            permisoBindingSource.DataSource = typeof(Security.Entidades.Permiso);
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(212, 9);
            label1.Name = "label1";
            label1.Size = new Size(52, 15);
            label1.TabIndex = 15;
            label1.Text = "Usuarios";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(515, 9);
            label2.Name = "label2";
            label2.Size = new Size(35, 15);
            label2.TabIndex = 16;
            label2.Text = "Roles";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(653, 9);
            label3.Name = "label3";
            label3.Size = new Size(55, 15);
            label3.TabIndex = 17;
            label3.Text = "Permisos";
            // 
            // gbRoles
            // 
            gbRoles.Controls.Add(btnEliminarRol);
            gbRoles.Controls.Add(btnAgregarRol);
            gbRoles.Location = new Point(462, 462);
            gbRoles.Name = "gbRoles";
            gbRoles.Size = new Size(144, 100);
            gbRoles.TabIndex = 18;
            gbRoles.TabStop = false;
            gbRoles.Text = "Roles";
            // 
            // btnEliminarRol
            // 
            btnEliminarRol.Location = new Point(6, 51);
            btnEliminarRol.Name = "btnEliminarRol";
            btnEliminarRol.Size = new Size(132, 23);
            btnEliminarRol.TabIndex = 1;
            btnEliminarRol.Text = "Eliminar Rol";
            btnEliminarRol.UseVisualStyleBackColor = true;
            // 
            // btnAgregarRol
            // 
            btnAgregarRol.Location = new Point(6, 22);
            btnAgregarRol.Name = "btnAgregarRol";
            btnAgregarRol.Size = new Size(132, 23);
            btnAgregarRol.TabIndex = 0;
            btnAgregarRol.Text = "Agregar Rol";
            btnAgregarRol.UseVisualStyleBackColor = true;
            // 
            // gbPermisos
            // 
            gbPermisos.Controls.Add(btnEliminarPermiso);
            gbPermisos.Controls.Add(btnAgregarPermiso);
            gbPermisos.Location = new Point(612, 462);
            gbPermisos.Name = "gbPermisos";
            gbPermisos.Size = new Size(144, 100);
            gbPermisos.TabIndex = 19;
            gbPermisos.TabStop = false;
            gbPermisos.Text = "Permisos";
            // 
            // btnEliminarPermiso
            // 
            btnEliminarPermiso.Location = new Point(6, 51);
            btnEliminarPermiso.Name = "btnEliminarPermiso";
            btnEliminarPermiso.Size = new Size(132, 23);
            btnEliminarPermiso.TabIndex = 1;
            btnEliminarPermiso.Text = "Eliminar Permiso";
            btnEliminarPermiso.UseVisualStyleBackColor = true;
            // 
            // btnAgregarPermiso
            // 
            btnAgregarPermiso.Location = new Point(6, 22);
            btnAgregarPermiso.Name = "btnAgregarPermiso";
            btnAgregarPermiso.Size = new Size(132, 23);
            btnAgregarPermiso.TabIndex = 0;
            btnAgregarPermiso.Text = "Agregar Permiso";
            btnAgregarPermiso.UseVisualStyleBackColor = true;
            // 
            // btnGuardarCambios
            // 
            btnGuardarCambios.Location = new Point(12, 513);
            btnGuardarCambios.Name = "btnGuardarCambios";
            btnGuardarCambios.Size = new Size(116, 23);
            btnGuardarCambios.TabIndex = 20;
            btnGuardarCambios.Text = "Guardar cambios";
            btnGuardarCambios.UseVisualStyleBackColor = true;
            btnGuardarCambios.Click += btnGuardarCambios_Click;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(766, 567);
            Controls.Add(btnGuardarCambios);
            Controls.Add(gbPermisos);
            Controls.Add(gbRoles);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(dgvPermisos);
            Controls.Add(dgvRoles);
            Controls.Add(dgvUsuarios);
            Name = "Form1";
            Text = "GVM Admin";
            Load += Form1_Load;
            ((System.ComponentModel.ISupportInitialize)dgvUsuarios).EndInit();
            ((System.ComponentModel.ISupportInitialize)usuarioBindingSource).EndInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvRoles).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvPermisos).EndInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).EndInit();
            gbRoles.ResumeLayout(false);
            gbPermisos.ResumeLayout(false);
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion
        private DataGridView dgvUsuarios;
        private BindingSource usuarioBindingSource;
        private DataGridViewTextBoxColumn usuarioIdDataGridViewTextBoxColumn;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn;
        private DataGridViewTextBoxColumn emailDataGridViewTextBoxColumn;
        private DataGridViewCheckBoxColumn habilitadoDataGridViewCheckBoxColumn;
        private BindingSource rolBindingSource;
        private DataGridView dgvRoles;
        private DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private DataGridView dgvPermisos;
        private DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
        private BindingSource permisoBindingSource;
        private Label label1;
        private Label label2;
        private Label label3;
        private GroupBox gbRoles;
        private Button btnEliminarRol;
        private Button btnAgregarRol;
        private GroupBox gbPermisos;
        private Button btnEliminarPermiso;
        private Button btnAgregarPermiso;
        private Button btnGuardarCambios;
    }
}