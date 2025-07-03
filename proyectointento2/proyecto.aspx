<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="proyecto.aspx.cs" Inherits="proyectointento2.proyecto" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Máquina Expendedora</title>
    <style>
        body { background: #fafafa; }
        .container { font-family: 'Segoe UI', sans-serif; margin: 40px auto; width: 800px; background: #fff; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        .controls { text-align: center; margin-bottom: 20px; }
        .controls label, .controls select, .controls input { font-size: 14px; vertical-align: middle; }
        .controls select, .controls input { padding: 5px; margin: 0 5px; border-radius: 4px; border: 1px solid #ccc; }
        .controls button { padding: 6px 12px; font-size: 14px; border: none; background-color: #007bff; color: #fff; border-radius: 4px; cursor: pointer; }
        .controls button:hover { background-color: #0069d9; }
        .grid-view { width: 100%; border-collapse: collapse; }
        .grid-view th, .grid-view td { border: 1px solid #ddd; padding: 12px; }
        .grid-view th { background-color: #007bff; color: #fff; }
        .grid-view tr:nth-child(even) { background-color: #f2f2f2; }
        .grid-view tr:hover { background-color: #e9ecef; }
        .error { color: red; text-align: center; }
        .success { color: green; text-align: center; }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container">
        <asp:MultiView ID="mvMain" runat="server" ActiveViewIndex="0">
            <!-- View 0: Login -->
            <asp:View ID="viewLogin" runat="server">
                <h2>Acceso al Sistema</h2>
                <asp:Label ID="lblLoginError" runat="server" CssClass="error" /><br />
                <div class="controls">
                    <asp:Label runat="server" Text="Usuario:" />
                    <asp:TextBox ID="txtUser" runat="server" />
                    <asp:Label runat="server" Text="Clave:" />
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password" />
                    <asp:Button ID="btnLogin" runat="server" Text="Entrar" OnClick="btnLogin_Click" />
                </div>
            </asp:View>
            <!-- View 1: Admin Menu -->
            <asp:View ID="viewMenu" runat="server">
                <h2>Menú Principal</h2>
                <asp:Label ID="lblMenuInfo" runat="server" CssClass="success" /><br />
                <div class="controls">
                    <asp:Button ID="btnGoAdmin" runat="server" Text="Administrar Usuarios" OnClick="btnGoAdmin_Click" />
                    <asp:Button ID="btnGoRefill" runat="server" Text="Reabastecer Productos" OnClick="btnGoRefill_Click" />
                    <asp:Button ID="btnGoSales" runat="server" Text="Ventas" OnClick="btnGoSales_Click" />
                    <asp:Button ID="btnLogout" runat="server" Text="Cerrar Sesión" OnClick="btnLogout_Click" />
                </div>
            </asp:View>
            <!-- View 2: Administrar Usuarios -->
            <asp:View ID="viewUsers" runat="server">
                <h2>Administración de Usuarios</h2>
                <asp:Label ID="lblUserMsg" runat="server" CssClass="success" /><br />
                <div class="controls">
                    <asp:TextBox ID="txtNewUser" runat="server" Placeholder="Nombre de usuario" />
                    <asp:TextBox ID="txtNewPass" runat="server" TextMode="Password" Placeholder="Clave" />
                    <asp:Button ID="btnAddUser" runat="server" Text="Agregar Usuario" OnClick="btnAddUser_Click" />
                </div>
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Username" HeaderText="Usuario" />
                    </Columns>
                </asp:GridView>
                <asp:Button ID="btnBackFromUsers" runat="server" Text="Volver al Menú" OnClick="btnBackMenu_Click" />
            </asp:View>
            <!-- View 3: Reabastecer Productos -->
            <asp:View ID="viewRefill" runat="server">
                <h2>Reabastecer Productos</h2>
                <asp:Label ID="lblRefillMsg" runat="server" CssClass="success" /><br />
                <div class="controls">
                    <asp:DropDownList ID="ddlRow" runat="server" />
                    <asp:DropDownList ID="ddlCol" runat="server" />
                    <asp:TextBox ID="txtUnits" runat="server" Width="50px" />
                    <asp:Button ID="btnRefill" runat="server" Text="Reabastecer" OnClick="btnRefill_Click" />
                </div>
                <asp:Button ID="btnBackFromRefill" runat="server" Text="Volver al Menú" OnClick="btnBackMenu_Click" />
            </asp:View>
            <!-- View 4: Ventas -->
            <asp:View ID="viewSales" runat="server">
                <h2>Ventas de Productos</h2>
                <asp:Label ID="lblSalesMsg" runat="server" CssClass="error" /><br />
                <div class="controls">
                    <asp:DropDownList ID="ddlRow2" runat="server" />
                    <asp:DropDownList ID="ddlCol2" runat="server" />
                    <asp:TextBox ID="txtAmount" runat="server" Width="80px" />
                    <asp:Button ID="btnBuy" runat="server" Text="Comprar" OnClick="btnBuy_Click" />
                </div>
                <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="false" CssClass="grid-view">
                    <Columns>
                        <asp:BoundField DataField="Row" HeaderText="Fila" />
                        <asp:BoundField DataField="Col" HeaderText="Columna" />
                        <asp:BoundField DataField="Product" HeaderText="Producto" />
                        <asp:BoundField DataField="Quantity" HeaderText="Cantidad" />
                        <asp:BoundField DataField="Price" HeaderText="Precio" DataFormatString="{0:C2}" />
                    </Columns>
                </asp:GridView>
                <asp:Button ID="btnBackFromSales" runat="server" Text="Volver al Menú" OnClick="btnBackMenu_Click" />
            </asp:View>
        </asp:MultiView>
    </form>
</body>
</html>
