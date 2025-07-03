using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace proyectointento2
{
    public partial class proyecto : Page
    {
        private const int Rows = 5;
        private const int Cols = 3;
        // Usuarios en memoria
        private static List<string> Users = new List<string> { "admin" };

        [Serializable]
        public class Product { public string Name; public decimal Price; }

        private Stack<Product>[,] Machine
        {
            get
            {
                if (Session["Machine"] == null) InitializeMachine();
                return (Stack<Product>[,])Session["Machine"];
            }
            set => Session["Machine"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) mvMain.ActiveViewIndex = 0;
        }

        // LOGIN
        protected void btnLogin_Click(object s, EventArgs e)
        {
            string user = txtUser.Text.Trim().ToLower();
            string pass = txtPass.Text; // no se valida password para demo
            if (!Users.Contains(user)) { lblLoginError.Text = "Usuario no existe."; return; }
            lblLoginError.Text = "";
            lblMenuInfo.Text = $"Bienvenido, {user}.";
            mvMain.ActiveViewIndex = 1;
        }

        // MENÚ
        protected void btnGoAdmin_Click(object s, EventArgs e) { SetupUsers(); mvMain.ActiveViewIndex = 2; }
        protected void btnGoRefill_Click(object s, EventArgs e) { SetupRefill(); mvMain.ActiveViewIndex = 3; }
        protected void btnGoSales_Click(object s, EventArgs e) { SetupSales(); mvMain.ActiveViewIndex = 4; }
        protected void btnLogout_Click(object s, EventArgs e) { mvMain.ActiveViewIndex = 0; }
        protected void btnBackMenu_Click(object s, EventArgs e) { mvMain.ActiveViewIndex = 1; }

        // ADMINISTRAR USUARIOS
        private void SetupUsers()
        {
            lblUserMsg.Text = "";
            gvUsers.DataSource = Users.ConvertAll(u => new { Username = u });
            gvUsers.DataBind();
        }
        protected void btnAddUser_Click(object s, EventArgs e)
        {
            string u = txtNewUser.Text.Trim().ToLower();
            if (string.IsNullOrEmpty(u) || Users.Contains(u)) { lblUserMsg.Text = "Usuario inválido o ya existe."; return; }
            Users.Add(u);
            SetupUsers();
            lblUserMsg.Text = $"Usuario {u} agregado.";
        }

        // REABASTECER
        private void SetupRefill()
        {
            lblRefillMsg.Text = "";
            ddlRow.Items.Clear(); ddlCol.Items.Clear();
            for (int i = 1; i <= Rows; i++) ddlRow.Items.Add(i.ToString());
            for (int j = 1; j <= Cols; j++) ddlCol.Items.Add(j.ToString());
        }
        protected void btnRefill_Click(object s, EventArgs e)
        {
            int r = int.Parse(ddlRow.SelectedValue) - 1;
            int c = int.Parse(ddlCol.SelectedValue) - 1;
            if (!int.TryParse(txtUnits.Text, out int units)) { lblRefillMsg.Text = "Unidades inválidas."; return; }
            var stack = Machine[r, c]; int added = 0;
            for (int k = 0; k < units && stack.Count < 5; k++) { stack.Push(stack.Peek()); added++; }
            lblRefillMsg.Text = $"Se agregaron {added} unidades.";
        }

        // VENTAS
        private void SetupSales()
        {
            lblSalesMsg.Text = "";
            ddlRow2.Items.Clear(); ddlCol2.Items.Clear();
            for (int i = 1; i <= Rows; i++) ddlRow2.Items.Add(i.ToString());
            for (int j = 1; j <= Cols; j++) ddlCol2.Items.Add(j.ToString());
            UpdateGrid();
        }
        protected void btnBuy_Click(object s, EventArgs e)
        {
            if (!int.TryParse(ddlRow2.SelectedValue, out int r) || !int.TryParse(ddlCol2.SelectedValue, out int c) || !decimal.TryParse(txtAmount.Text, out decimal amt))
            { lblSalesMsg.Text = "Código o monto inválido."; return; }
            var stack = Machine[r - 1, c - 1];
            if (stack.Count == 0) lblSalesMsg.Text = "Producto no disponible.";
            else if (amt < stack.Peek().Price) lblSalesMsg.Text = "Fondos insuficientes.";
            else { stack.Pop(); lblSalesMsg.Text = $"Venta exitosa."; UpdateGrid(); }
        }

        // DIBUJAR TABLA
        private void UpdateGrid()
        {
            var dt = new DataTable();
            dt.Columns.Add("Row", typeof(int)); dt.Columns.Add("Col", typeof(int));
            dt.Columns.Add("Product", typeof(string)); dt.Columns.Add("Quantity", typeof(int)); dt.Columns.Add("Price", typeof(decimal));
            var m = Machine;
            for (int i = 0; i < Rows; i++) for (int j = 0; j < Cols; j++) dt.Rows.Add(i + 1, j + 1, m[i, j].Count > 0 ? m[i, j].Peek().Name : "--", m[i, j].Count, m[i, j].Count > 0 ? m[i, j].Peek().Price : 0m);
            gvInventory.DataSource = dt; gvInventory.DataBind();
        }

        // INICIALIZAR MÁQUINA
        private void InitializeMachine()
        {
            var matrix = new Stack<Product>[Rows, Cols];
            for (int i = 0; i < Rows; i++) for (int j = 0; j < Cols; j++) { var st = new Stack<Product>(); for (int k = 0; k < 5; k++) st.Push(new Product { Name = $"P{i + 1}-{j + 1}", Price = 1.50m * (i + 1) }); matrix[i, j] = st; }
            Session["Machine"] = matrix;
        }
    }
}
