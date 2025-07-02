// File: proyecto.aspx (WebForms markup)
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="proyecto.aspx.cs" Inherits="proyectointento2.proyecto" %>

// File: proyecto.aspx.cs (Code-behind)
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace proyectointento2
{
public partial class proyecto : Page
{
// Tamaño de la matriz
private const int Rows = 5;
private const int Cols = 3;
// Clase para producto
    [Serializable]
    public class Product
    {
        public string Name { get; set; }
        public decimal Price { get; set; }
    }

    // Inventario en sesión: matriz de pilas
    private Stack<Product>[,] Machine
    {
        get
        {
            if (Session["Machine"] == null)
                InitializeMachine();
            return (Stack<Product>[,])Session["Machine"];
        }
        set => Session["Machine"] = value;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDropdowns();
            UpdateGrid();
        }
    }

    // Configura dropdowns para filas y columnas
    private void BindDropdowns()
    {
        ddlRow.Items.Clear();
        ddlCol.Items.Clear();
        for (int i = 1; i <= Rows; i++) ddlRow.Items.Add(i.ToString());
        for (int j = 1; j <= Cols; j++) ddlCol.Items.Add(j.ToString());
    }

    // Inicializa máquina con 5 unidades por casilla
    private void InitializeMachine()
    {
        var matrix = new Stack<Product>[Rows, Cols];
        for (int i = 0; i < Rows; i++)
        {
            for (int j = 0; j < Cols; j++)
            {
                var stack = new Stack<Product>();
                for (int k = 0; k < 5; k++)
                    // Uso de pila: último en entrar, primero en salir
                    stack.Push(new Product
                    {
                        Name = $"Producto {i+1}-{j+1}",
                        Price = 2.00m + i * 0.50m  // precios escalonados por fila
                    });
                matrix[i, j] = stack;
            }
        }
        Machine = matrix;
    }

    // Rellena el GridView con el estado actual de la máquina
    private void UpdateGrid()
    {
        var table = new DataTable();
        table.Columns.Add("Row", typeof(int));
        table.Columns.Add("Col", typeof(int));
        table.Columns.Add("Product", typeof(string));
        table.Columns.Add("Quantity", typeof(int));
        table.Columns.Add("Price", typeof(decimal));

        for (int i = 0; i < Rows; i++)
        {
            for (int j = 0; j < Cols; j++)
            {
                var stack = Machine[i, j];
                var name = stack.Count > 0 ? stack.Peek().Name : "--";
                var qty = stack.Count;
                var price = stack.Count > 0 ? stack.Peek().Price : 0m;
                table.Rows.Add(i + 1, j + 1, name, qty, price);
            }
        }

        gvInventory.DataSource = table;
        gvInventory.DataBind();
    }

    // Maneja la compra de un producto
    protected void btnBuy_Click(object sender, EventArgs e)
    {
        lblMessage.ForeColor = System.Drawing.Color.Red;
        // Validaciones de entrada
        if (!int.TryParse(ddlRow.SelectedValue, out int r)
            || !int.TryParse(ddlCol.SelectedValue, out int c)
            || !decimal.TryParse(txtAmount.Text, out decimal amount))
        {
            lblMessage.Text = "Códigos o monto inválidos.";
            return;
        }

        var stack = Machine[r - 1, c - 1];
        if (stack.Count == 0)
        {
            lblMessage.Text = "Producto no disponible.";
        }
        else if (amount < stack.Peek().Price)
        {
            lblMessage.Text = "Fondos insuficientes.";
        }
        else
        {
            // Venta: desapilar producto
            var sold = stack.Pop();
            var change = amount - sold.Price;
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = $"Compra exitosa: {sold.Name}. Vuelto: {change:C2}";
            UpdateGrid();
        }
    }
}