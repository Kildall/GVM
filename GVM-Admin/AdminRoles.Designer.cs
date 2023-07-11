namespace GVM_Admin {
    partial class AdminRoles {
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
            rolBindingSource = new BindingSource(components);
            dgvUsuario = new DataGridView();
            nombreDataGridViewTextBoxColumn1 = new DataGridViewTextBoxColumn();
            rolBindingSource1 = new BindingSource(components);
            btnAgregar = new Button();
            btnSacar = new Button();
            label1 = new Label();
            label2 = new Label();
            ((System.ComponentModel.ISupportInitialize)dgvSistema).BeginInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dgvUsuario).BeginInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource1).BeginInit();
            SuspendLayout();
            // 
            // dgvSistema
            // 
            dgvSistema.AutoGenerateColumns = false;
            dgvSistema.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvSistema.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn });
            dgvSistema.DataSource = rolBindingSource;
            dgvSistema.Location = new Point(12, 24);
            dgvSistema.Name = "dgvSistema";
            dgvSistema.RowTemplate.Height = 25;
            dgvSistema.Size = new Size(264, 414);
            dgvSistema.TabIndex = 0;
            // 
            // nombreDataGridViewTextBoxColumn
            // 
            nombreDataGridViewTextBoxColumn.DataPropertyName = "Nombre";
            nombreDataGridViewTextBoxColumn.HeaderText = "Nombre";
            nombreDataGridViewTextBoxColumn.Name = "nombreDataGridViewTextBoxColumn";
            // 
            // rolBindingSource
            // 
            rolBindingSource.DataSource = typeof(Security.Entidades.Rol);
            // 
            // dgvUsuario
            // 
            dgvUsuario.AutoGenerateColumns = false;
            dgvUsuario.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvUsuario.Columns.AddRange(new DataGridViewColumn[] { nombreDataGridViewTextBoxColumn1 });
            dgvUsuario.DataSource = rolBindingSource1;
            dgvUsuario.Location = new Point(443, 24);
            dgvUsuario.Name = "dgvUsuario";
            dgvUsuario.RowTemplate.Height = 25;
            dgvUsuario.Size = new Size(256, 414);
            dgvUsuario.TabIndex = 1;
            // 
            // nombreDataGridViewTextBoxColumn1
            // 
            nombreDataGridViewTextBoxColumn1.DataPropertyName = "Nombre";
            nombreDataGridViewTextBoxColumn1.HeaderText = "Nombre";
            nombreDataGridViewTextBoxColumn1.Name = "nombreDataGridViewTextBoxColumn1";
            // 
            // rolBindingSource1
            // 
            rolBindingSource1.DataSource = typeof(Security.Entidades.Rol);
            // 
            // btnAgregar
            // 
            btnAgregar.Location = new Point(319, 182);
            btnAgregar.Name = "btnAgregar";
            btnAgregar.Size = new Size(75, 23);
            btnAgregar.TabIndex = 2;
            btnAgregar.Text = "->";
            btnAgregar.UseVisualStyleBackColor = true;
            btnAgregar.Click += btnAgregar_Click;
            // 
            // btnSacar
            // 
            btnSacar.Location = new Point(319, 211);
            btnSacar.Name = "btnSacar";
            btnSacar.Size = new Size(75, 23);
            btnSacar.TabIndex = 3;
            btnSacar.Text = "<-";
            btnSacar.UseVisualStyleBackColor = true;
            btnSacar.Click += btnSacar_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(113, 6);
            label1.Name = "label1";
            label1.Size = new Size(48, 15);
            label1.TabIndex = 4;
            label1.Text = "Sistema";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(549, 6);
            label2.Name = "label2";
            label2.Size = new Size(47, 15);
            label2.TabIndex = 5;
            label2.Text = "Usuario";
            // 
            // AgregarRol
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(711, 450);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(btnSacar);
            Controls.Add(btnAgregar);
            Controls.Add(dgvUsuario);
            Controls.Add(dgvSistema);
            Name = "AdminRoles";
            Text = "Agregar Rol";
            Load += AgregarRol_Load;
            ((System.ComponentModel.ISupportInitialize)dgvSistema).EndInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource).EndInit();
            ((System.ComponentModel.ISupportInitialize)dgvUsuario).EndInit();
            ((System.ComponentModel.ISupportInitialize)rolBindingSource1).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private DataGridView dgvSistema;
        private DataGridView dgvUsuario;
        private Button btnAgregar;
        private Button btnSacar;
        private Label label1;
        private Label label2;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn;
        private BindingSource rolBindingSource;
        private DataGridViewTextBoxColumn nombreDataGridViewTextBoxColumn1;
        private BindingSource rolBindingSource1;
    }
}