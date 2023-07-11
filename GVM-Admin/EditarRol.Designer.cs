namespace GVM_Admin {
    partial class EditarRol {
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
            dgvSistema = new DataGridView();
            nombreDataGridViewTextBoxColumn = new DataGridViewTextBoxColumn();
            permisoBindingSource = new BindingSource(components);
            dgvPermisosRol = new DataGridView();
            nombreDataGridViewTextBoxColumn1 = new DataGridViewTextBoxColumn();
            permisoBindingSource1 = new BindingSource(components);
            tbNombre = new TextBox();
            label1 = new Label();
            groupBox1 = new GroupBox();
            btnSacar = new Button();
            btnAgregar = new Button();
            label2 = new Label();
            label3 = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvSistema).BeginInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvPermisosRol).BeginInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource1).BeginInit();
            groupBox1.SuspendLayout();
            SuspendLayout();
            // 
            // dgvSistema
            // 
            dgvSistema.AutoGenerateColumns = false;
            dgvSistema.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvSistema.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn });
            dgvSistema.DataSource = permisoBindingSource;
            dgvSistema.Location = new Point(12, 34);
            dgvSistema.Name = "dgvSistema";
            dgvSistema.RowTemplate.Height = 25;
            dgvSistema.Size = new Size(200, 404);
            dgvSistema.TabIndex = 1;
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
            // dgvRol
            // 
            dgvPermisosRol.AutoGenerateColumns = false;
            dgvPermisosRol.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvPermisosRol.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn1 });
            dgvPermisosRol.DataSource = permisoBindingSource1;
            dgvPermisosRol.Location = new Point(424, 34);
            dgvPermisosRol.Name = "dgvPermisosRol";
            dgvPermisosRol.RowTemplate.Height = 25;
            dgvPermisosRol.Size = new Size(196, 404);
            dgvPermisosRol.TabIndex = 2;
            // 
            // nombreDataGridViewTextBoxColumn1
            // 
            nombreDataGridViewTextBoxColumn1.DataPropertyName = "Nombre";
            nombreDataGridViewTextBoxColumn1.HeaderText = "Nombre";
            nombreDataGridViewTextBoxColumn1.Name = "nombreDataGridViewTextBoxColumn1";
            // 
            // permisoBindingSource1
            // 
            permisoBindingSource1.DataSource = typeof(Security.Entidades.Permiso);
            // 
            // tbNombre
            // 
            tbNombre.Location = new Point(72, 22);
            tbNombre.Name = "tbNombre";
            tbNombre.Size = new Size(122, 23);
            tbNombre.TabIndex = 0;
            tbNombre.TextChanged += tbNombre_TextChanged;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(15, 25);
            label1.Name = "label1";
            label1.Size = new Size(51, 15);
            label1.TabIndex = 1;
            label1.Text = "Nombre";
            // 
            // groupBox1
            // 
            groupBox1.Controls.Add(label1);
            groupBox1.Controls.Add(tbNombre);
            groupBox1.Location = new Point(218, 12);
            groupBox1.Name = "groupBox1";
            groupBox1.Size = new Size(200, 63);
            groupBox1.TabIndex = 0;
            groupBox1.TabStop = false;
            // 
            // btnSacar
            // 
            btnSacar.Location = new Point(280, 220);
            btnSacar.Name = "btnSacar";
            btnSacar.Size = new Size(75, 23);
            btnSacar.TabIndex = 5;
            btnSacar.Text = "<-";
            btnSacar.UseVisualStyleBackColor = true;
            btnSacar.Click += btnSacar_Click;
            // 
            // btnAgregar
            // 
            btnAgregar.Location = new Point(280, 191);
            btnAgregar.Name = "btnAgregar";
            btnAgregar.Size = new Size(75, 23);
            btnAgregar.TabIndex = 4;
            btnAgregar.Text = "->";
            btnAgregar.UseVisualStyleBackColor = true;
            btnAgregar.Click += btnAgregar_Click;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(73, 12);
            label2.Name = "label2";
            label2.Size = new Size(48, 15);
            label2.TabIndex = 6;
            label2.Text = "Sistema";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(500, 12);
            label3.Name = "label3";
            label3.Size = new Size(24, 15);
            label3.TabIndex = 7;
            label3.Text = "Rol";
            // 
            // EditarRol
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(630, 450);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(btnSacar);
            Controls.Add(btnAgregar);
            Controls.Add(dgvPermisosRol);
            Controls.Add(dgvSistema);
            Controls.Add(groupBox1);
            Name = "EditarRol";
            Text = "Editar Rol";
            Load += EditarRol_Load;
            ((System.ComponentModel.ISupportInitialize)dgvSistema).EndInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvPermisosRol).EndInit();
            ((System.ComponentModel.ISupportInitialize)permisoBindingSource1).EndInit();
            groupBox1.ResumeLayout(false);
            groupBox1.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private DataGridView dgvSistema;
        private DataGridView dgvPermisosRol;
        private TextBox tbNombre;
        private Label label1;
        private GroupBox groupBox1;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn;
        private BindingSource permisoBindingSource;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn1;
        private BindingSource permisoBindingSource1;
        private Button btnSacar;
        private Button btnAgregar;
        private Label label2;
        private Label label3;
    }
}