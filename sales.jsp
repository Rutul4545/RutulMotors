<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="Dao.DBConnection" %>

<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("customerDashboard.jsp");
        return;
    }

    DecimalFormat indianFormat =
        new DecimalFormat("#,##0.00");

    DecimalFormat wholeIndianFormat =
        new DecimalFormat("#,##0");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Sales Management | Rutul Motors</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Segoe UI", Arial, sans-serif;
}

body {
    background: #f4f6f9;
    color: #222;
}

.navbar {
    height: 72px;
    background: #111827;
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 5%;
}

.logo {
    font-size: 25px;
    font-weight: 800;
}

.logo span {
    color: #ff9800;
}

.nav-links {
    display: flex;
    gap: 25px;
    align-items: center;
}

.nav-links a {
    color: #e5e7eb;
    text-decoration: none;
    font-size: 15px;
}

.nav-links a:hover {
    color: #ff9800;
}

.logout {
    background: #dc3545;
    padding: 9px 17px;
    border-radius: 7px;
}

.container {
    width: 92%;
    max-width: 1400px;
    margin: 40px auto;
}

.header {
    margin-bottom: 30px;
}

.header h1 {
    font-size: 32px;
    color: #111827;
}

.header p {
    color: #6b7280;
    margin-top: 8px;
}

.form-card {
    background: white;
    padding: 30px;
    border-radius: 16px;
    box-shadow:
        0 8px 25px rgba(0,0,0,0.07);
    margin-bottom: 35px;
}

.form-card h2 {
    color: #111827;
    margin-bottom: 25px;
}

.form-grid {
    display: grid;
    grid-template-columns:
        repeat(3, 1fr);
    gap: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #374151;
}

.form-group input,
.form-group select {
    width: 100%;
    padding: 12px 14px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 15px;
    outline: none;
}

.form-group input:focus,
.form-group select:focus {
    border-color: #ff9800;
    box-shadow:
        0 0 0 3px
        rgba(255,152,0,0.12);
}

.submit-btn {
    margin-top: 25px;
    padding: 13px 25px;
    border: none;
    border-radius: 8px;
    background: #ff9800;
    color: #111827;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
}

.submit-btn:hover {
    background: #ffb300;
}

.table-card {
    background: white;
    padding: 25px;
    border-radius: 16px;
    box-shadow:
        0 8px 25px rgba(0,0,0,0.07);
    overflow-x: auto;
}

.table-card h2 {
    margin-bottom: 25px;
    color: #111827;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th {
    background: #111827;
    color: white;
    padding: 14px;
    text-align: left;
    font-size: 14px;
}

td {
    padding: 14px;
    border-bottom:
        1px solid #e5e7eb;
    color: #374151;
}

tr:hover {
    background: #f9fafb;
}

.price {
    color: #111827;
    font-weight: 800;
}

.stock {
    display: inline-block;
    background: #dcfce7;
    color: #166534;
    padding: 5px 9px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
}

.error {
    background: #fee2e2;
    color: #991b1b;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 20px;
}

.success {
    background: #dcfce7;
    color: #166534;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 20px;
}

.empty {
    text-align: center;
    padding: 45px;
    color: #6b7280;
}

.empty h3 {
    color: #374151;
    margin-bottom: 8px;
}

@media(max-width: 900px) {

    .form-grid {
        grid-template-columns: 1fr;
    }

    .nav-links {
        gap: 10px;
    }

    .nav-links a {
        font-size: 12px;
    }
}

</style>

</head>

<body>

<div class="navbar">

    <div class="logo">
        RUTUL <span>MOTORS</span>
    </div>

    <div class="nav-links">

        <a href="dashboard.jsp">
            Dashboard
        </a>

        <a href="vehicles.jsp">
            Manage Vehicles
        </a>

        <a href="manageBookings.jsp">
            Manage Bookings
        </a>

        <a href="sales.jsp">
            Sales Management
        </a>

        <a href="about.jsp">
            About Us
        </a>

        <a href="logout"
           class="logout">
            Logout
        </a>

    </div>

</div>

<div class="container">

    <div class="header">

        <h1>
            Sales Management
        </h1>

        <p>
            Record and manage commercial vehicle sales.
        </p>

    </div>

<%
    String success =
        request.getParameter("success");

    String error =
        request.getParameter("error");

    if ("true".equals(success)) {
%>

    <div class="success">
        Sale recorded successfully.
        Vehicle stock has been updated.
    </div>

<%
    }

    if (error != null) {
%>

    <div class="error">
        <%= error %>
    </div>

<%
    }
%>

    <div class="form-card">

        <h2>
            Record New Sale
        </h2>

        <form action="SalesServlet"
              method="post">

            <div class="form-grid">

                <div class="form-group">

                    <label>
                        Select Vehicle
                    </label>

                    <select name="vehicle_id"
                            required>

                        <option value="">
                            Select Vehicle
                        </option>

<%
    try {

        Connection con =
            DBConnection.getConnection();

        PreparedStatement ps =
            con.prepareStatement(
                "SELECT vehicle_id, vehicle_name, " +
                "brand, price, stock " +
                "FROM vehicles " +
                "WHERE stock > 0 " +
                "ORDER BY vehicle_name"
            );

        ResultSet rs =
            ps.executeQuery();

        while (rs.next()) {

            double vehiclePrice =
                rs.getDouble("price");

            String formattedPrice =
                wholeIndianFormat.format(
                    vehiclePrice
                );
%>

                        <option
                            value="<%= rs.getInt("vehicle_id") %>">

                            <%= rs.getString("vehicle_name") %>
                            -
                            <%= rs.getString("brand") %>
                            -
                            ₹<%= formattedPrice %>
                            -
                            Stock:
                            <%= rs.getInt("stock") %>

                        </option>

<%
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
%>

                        <option value="">
                            Unable to load vehicles
                        </option>

<%
    }
%>

                    </select>

                </div>

                <div class="form-group">

                    <label>
                        Select Customer
                    </label>

                    <select name="customer_id"
                            required>

                        <option value="">
                            Select Customer
                        </option>

<%
    try {

        Connection con =
            DBConnection.getConnection();

        PreparedStatement ps =
            con.prepareStatement(
                "SELECT user_id, full_name, email " +
                "FROM users " +
                "WHERE role = 'CUSTOMER' " +
                "ORDER BY full_name"
            );

        ResultSet rs =
            ps.executeQuery();

        while (rs.next()) {
%>

                        <option
                            value="<%= rs.getInt("user_id") %>">

                            <%= rs.getString("full_name") %>
                            -
                            <%= rs.getString("email") %>

                        </option>

<%
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
%>

                        <option value="">
                            Unable to load customers
                        </option>

<%
    }
%>

                    </select>

                </div>

                <div class="form-group">

                    <label>
                        Sale Amount
                    </label>

                    <input
                        type="number"
                        name="amount"
                        step="0.01"
                        min="0"
                        placeholder="Enter sale amount"
                        required>

                </div>

            </div>

            <button type="submit"
                    class="submit-btn">

                Record Sale

            </button>

        </form>

    </div>

    <div class="table-card">

        <h2>
            Sales History
        </h2>

<%
    boolean found = false;

    try {

        Connection con =
            DBConnection.getConnection();

        String sql =
            "SELECT s.sale_id, " +
            "s.sale_date, " +
            "s.amount, " +
            "v.vehicle_name, " +
            "v.brand, " +
            "u.full_name, " +
            "u.email " +
            "FROM sales s " +
            "LEFT JOIN vehicles v " +
            "ON s.vehicle_id = v.vehicle_id " +
            "LEFT JOIN users u " +
            "ON s.customer_id = u.user_id " +
            "ORDER BY s.sale_id DESC";

        PreparedStatement ps =
            con.prepareStatement(sql);

        ResultSet rs =
            ps.executeQuery();

        if (rs.next()) {

            found = true;
%>

        <table>

            <thead>

                <tr>

                    <th>
                        Sale ID
                    </th>

                    <th>
                        Vehicle
                    </th>

                    <th>
                        Brand
                    </th>

                    <th>
                        Customer
                    </th>

                    <th>
                        Email
                    </th>

                    <th>
                        Sale Date
                    </th>

                    <th>
                        Amount
                    </th>

                </tr>

            </thead>

            <tbody>

<%
            do {

                double saleAmount =
                    rs.getDouble("amount");

                String formattedAmount =
                    wholeIndianFormat.format(
                        saleAmount
                    );
%>

                <tr>

                    <td>
                        #<%= rs.getInt("sale_id") %>
                    </td>

                    <td>
                        <strong>
                            <%= rs.getString("vehicle_name") %>
                        </strong>
                    </td>

                    <td>
                        <%= rs.getString("brand") %>
                    </td>

                    <td>
                        <%= rs.getString("full_name") %>
                    </td>

                    <td>
                        <%= rs.getString("email") %>
                    </td>

                    <td>
                        <%= rs.getDate("sale_date") %>
                    </td>

                    <td class="price">
                        ₹<%= formattedAmount %>
                    </td>

                </tr>

<%
            } while (rs.next());
%>

            </tbody>

        </table>

<%
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
%>

        <div class="error">

            Unable to load sales:
            <%= e.getMessage() %>

        </div>

<%
    }

    if (!found) {
%>

        <div class="empty">

            <h3>
                No Sales Recorded
            </h3>

            <p>
                Sales will appear here after
                you record your first sale.
            </p>

        </div>

<%
    }
%>

    </div>

</div>

</body>

</html>