<%@ page import="java.sql.*" %>
<%@ page import="Dao.DBConnection" %>

<%
    String user = (String) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }

    int editId = 0;
    String editName = "";
    String editType = "";
    String editBrand = "";
    double editPrice = 0;
    int editStock = 0;

    String editParam = request.getParameter("edit");

    /*
     * LOAD VEHICLE FOR EDIT
     */
    if (editParam != null && !editParam.trim().isEmpty()) {

        try {

            editId = Integer.parseInt(editParam);

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT vehicle_id, vehicle_name, vehicle_type, brand, price, stock " +
                "FROM vehicles WHERE vehicle_id=?"
            );

            ps.setInt(1, editId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                editName = rs.getString("vehicle_name");
                editType = rs.getString("vehicle_type");
                editBrand = rs.getString("brand");
                editPrice = rs.getDouble("price");
                editStock = rs.getInt("stock");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Vehicle Management | Rutul Motors</title>


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


/* NAVBAR */

.navbar {

    height: 72px;

    background: #111827;

    color: white;

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding: 0 5%;

    box-shadow:
        0 3px 12px rgba(0,0,0,0.15);
}


.logo {

    font-size: 25px;

    font-weight: 800;

    letter-spacing: 1px;
}


.logo span {

    color: #ff9800;
}


.nav-links {

    display: flex;

    align-items: center;

    gap: 25px;
}


.nav-links a {

    color: #e5e7eb;

    text-decoration: none;

    font-size: 15px;

    transition: 0.3s;
}


.nav-links a:hover {

    color: #ff9800;
}


/* MAIN CONTAINER */

.container {

    width: 92%;

    max-width: 1300px;

    margin: 40px auto;
}


/* PAGE HEADER */

.page-header {

    margin-bottom: 30px;
}


.page-header h1 {

    font-size: 32px;

    color: #111827;

    margin-bottom: 7px;
}


.page-header p {

    color: #6b7280;

    font-size: 15px;
}


/* FORM CARD */

.form-card {

    background: white;

    padding: 32px;

    border-radius: 16px;

    box-shadow:
        0 8px 25px rgba(0,0,0,0.07);

    margin-bottom: 35px;
}


.form-card h2 {

    color: #111827;

    margin-bottom: 25px;

    font-size: 22px;
}


/* FORM GRID */

.form-grid {

    display: grid;

    grid-template-columns:
        repeat(2, 1fr);

    gap: 22px;
}


.form-group label {

    display: block;

    margin-bottom: 8px;

    font-size: 14px;

    font-weight: 600;

    color: #374151;
}


.form-group input,
.form-group select {

    width: 100%;

    padding: 13px 14px;

    border: 1px solid #d1d5db;

    border-radius: 9px;

    font-size: 15px;

    outline: none;

    background: white;
}


.form-group input:focus,
.form-group select:focus {

    border-color: #ff9800;

    box-shadow:
        0 0 0 3px rgba(255,152,0,0.12);
}


/* BUTTONS */

.btn {

    margin-top: 25px;

    padding: 13px 25px;

    border: none;

    border-radius: 9px;

    background: #ff9800;

    color: #111827;

    font-size: 15px;

    font-weight: 700;

    cursor: pointer;

    transition: 0.3s;
}


.btn:hover {

    background: #ffb300;

    transform: translateY(-1px);
}


.cancel {

    display: inline-block;

    margin-top: 25px;

    margin-left: 8px;

    padding: 13px 25px;

    border-radius: 9px;

    background: #6b7280;

    color: white;

    text-decoration: none;

    font-size: 15px;

    font-weight: 600;
}


.cancel:hover {

    background: #4b5563;
}


/* TABLE CARD */

.table-card {

    background: white;

    padding: 32px;

    border-radius: 16px;

    box-shadow:
        0 8px 25px rgba(0,0,0,0.07);

    overflow-x: auto;
}


.table-header {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 22px;
}


.table-header h2 {

    color: #111827;

    font-size: 22px;
}


.table-header p {

    color: #6b7280;

    font-size: 14px;
}


/* TABLE */

table {

    width: 100%;

    border-collapse: collapse;

    min-width: 850px;
}


thead th {

    background: #111827;

    color: white;

    padding: 15px;

    text-align: left;

    font-size: 14px;
}


tbody td {

    padding: 15px;

    border-bottom: 1px solid #e5e7eb;

    color: #374151;

    font-size: 14px;
}


tbody tr:hover {

    background: #f9fafb;
}


/* VEHICLE NAME */

.vehicle-name {

    font-weight: 700;

    color: #111827;
}


/* PRICE */

.price {

    font-weight: 600;

    color: #111827;
}


/* STOCK */

.stock {

    font-weight: 700;

    padding: 5px 10px;

    border-radius: 20px;

    display: inline-block;
}


.available {

    color: #166534;

    background: #dcfce7;
}


.out {

    color: #991b1b;

    background: #fee2e2;
}


/* ACTION BUTTONS */

.actions {

    white-space: nowrap;
}


.edit {

    display: inline-block;

    background: #2563eb;

    color: white;

    padding: 8px 14px;

    border-radius: 7px;

    text-decoration: none;

    font-size: 13px;

    font-weight: 600;

    margin-right: 5px;

    transition: 0.3s;
}


.edit:hover {

    background: #1d4ed8;
}


.delete {

    display: inline-block;

    background: #dc3545;

    color: white;

    padding: 8px 14px;

    border-radius: 7px;

    text-decoration: none;

    font-size: 13px;

    font-weight: 600;

    transition: 0.3s;
}


.delete:hover {

    background: #b02a37;
}


/* EMPTY */

.empty {

    text-align: center;

    padding: 35px;

    color: #6b7280;
}


/* RESPONSIVE */

@media(max-width: 800px) {

    .form-grid {

        grid-template-columns: 1fr;
    }

    .navbar {

        padding: 0 20px;
    }

    .nav-links {

        gap: 10px;
    }

    .nav-links a {

        font-size: 13px;
    }

    .container {

        width: 95%;
    }
}

</style>

</head>


<body>


<!-- NAVIGATION -->

<div class="navbar">


    <div class="logo">

        RUTUL <span>MOTORS</span>

    </div>


    <div class="nav-links">

        <a href="dashboard.jsp">
            Dashboard
        </a>

        <a href="vehicles.jsp">
            Vehicles
        </a>

        <a href="about.jsp">
            About Us
        </a>

        <a href="logout">
            Logout
        </a>

    </div>


</div>


<!-- MAIN -->

<div class="container">


    <!-- HEADER -->

    <div class="page-header">

        <h1>
            Vehicle Management
        </h1>

        <p>
            Manage commercial vehicles,
            inventory and stock at Rutul Motors.
        </p>

    </div>


    <!-- ADD / UPDATE FORM -->

    <div class="form-card">


        <h2>

            <% if (editId > 0) { %>

                Update Vehicle

            <% } else { %>

                Add New Vehicle

            <% } %>

        </h2>


        <form
            action="VehicleServlet"
            method="post">


            <!-- ACTION -->

            <input
                type="hidden"
                name="action"
                value="<%= editId > 0 ? "update" : "add" %>">


            <!-- VEHICLE ID FOR UPDATE -->

            <% if (editId > 0) { %>

                <input
                    type="hidden"
                    name="vehicle_id"
                    value="<%= editId %>">

            <% } %>


            <div class="form-grid">


                <!-- VEHICLE NAME -->

                <div class="form-group">

                    <label>
                        Vehicle Name
                    </label>

                    <input
                        type="text"
                        name="vehicle_name"
                        value="<%= editName %>"
                        placeholder="Example: Tata Prima"
                        required>

                </div>


                <!-- VEHICLE TYPE -->

                <div class="form-group">

                    <label>
                        Vehicle Type
                    </label>

                    <select
                        name="vehicle_type"
                        required>

                        <option value="">
                            Select Vehicle Type
                        </option>

                        <option value="Truck"
                            <%= "Truck".equals(editType)
                                ? "selected"
                                : "" %>>
                            Truck
                        </option>

                        <option value="Tipper"
                            <%= "Tipper".equals(editType)
                                ? "selected"
                                : "" %>>
                            Tipper
                        </option>

                        <option value="Pickup"
                            <%= "Pickup".equals(editType)
                                ? "selected"
                                : "" %>>
                            Pickup
                        </option>

                        <option value="Bus"
                            <%= "Bus".equals(editType)
                                ? "selected"
                                : "" %>>
                            Bus
                        </option>

                        <option value="Other"
                            <%= "Other".equals(editType)
                                ? "selected"
                                : "" %>>
                            Other
                        </option>

                    </select>

                </div>


                <!-- BRAND -->

                <div class="form-group">

                    <label>
                        Brand
                    </label>

                    <input
                        type="text"
                        name="brand"
                        value="<%= editBrand %>"
                        placeholder="Example: Tata"
                        required>

                </div>


                <!-- PRICE -->

                <div class="form-group">

                    <label>
                        Price
                    </label>

                    <input
                        type="number"
                        name="price"
                        value="<%= editId > 0 ? editPrice : "" %>"
                        placeholder="Enter vehicle price"
                        min="0"
                        step="0.01"
                        required>

                </div>


                <!-- STOCK -->

                <div class="form-group">

                    <label>
                        Stock Quantity
                    </label>

                    <input
                        type="number"
                        name="stock"
                        value="<%= editId > 0 ? editStock : 0 %>"
                        placeholder="Enter stock"
                        min="0"
                        required>

                </div>


            </div>


            <!-- SUBMIT -->

            <button
                type="submit"
                class="btn">

                <% if (editId > 0) { %>

                    Update Vehicle

                <% } else { %>

                    Add Vehicle

                <% } %>

            </button>


            <!-- CANCEL -->

            <% if (editId > 0) { %>

                <a
                    href="vehicles.jsp"
                    class="cancel">

                    Cancel

                </a>

            <% } %>


        </form>


    </div>


    <!-- VEHICLE INVENTORY -->

    <div class="table-card">


        <div class="table-header">

            <div>

                <h2>
                    Vehicle Inventory
                </h2>

                <p>
                    All vehicles currently registered
                    in the showroom.
                </p>

            </div>

        </div>


        <table>


            <thead>

                <tr>

                    <th>
                        ID
                    </th>

                    <th>
                        Vehicle Name
                    </th>

                    <th>
                        Type
                    </th>

                    <th>
                        Brand
                    </th>

                    <th>
                        Price
                    </th>

                    <th>
                        Stock
                    </th>

                    <th>
                        Actions
                    </th>

                </tr>

            </thead>


            <tbody>


<%

    boolean hasVehicles = false;

    try {

        Connection con =
            DBConnection.getConnection();


        PreparedStatement ps =
            con.prepareStatement(
                "SELECT vehicle_id, vehicle_name, " +
                "vehicle_type, brand, price, stock " +
                "FROM vehicles " +
                "ORDER BY vehicle_id DESC"
            );


        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

            hasVehicles = true;

%>


                <tr>


                    <!-- ID -->

                    <td>

                        <%= rs.getInt("vehicle_id") %>

                    </td>


                    <!-- NAME -->

                    <td>

                        <span class="vehicle-name">

                            <%= rs.getString(
                                "vehicle_name"
                            ) %>

                        </span>

                    </td>


                    <!-- TYPE -->

                    <td>

                        <%= rs.getString(
                            "vehicle_type"
                        ) %>

                    </td>


                    <!-- BRAND -->

                    <td>

                        <%= rs.getString(
                            "brand"
                        ) %>

                    </td>


                    <!-- PRICE -->

                    <td>

                        <span class="price">

                            Rs.
                            <%= String.format(
                                "%,.2f",
                                rs.getDouble("price")
                            ) %>

                        </span>

                    </td>


                    <!-- STOCK -->

                    <td>


                        <% if (rs.getInt("stock") > 0) { %>

                            <span class="stock available">

                                <%= rs.getInt("stock") %>
                                Available

                            </span>

                        <% } else { %>

                            <span class="stock out">

                                Out of Stock

                            </span>

                        <% } %>


                    </td>


                    <!-- ACTIONS -->

                    <td class="actions">


                        <!-- EDIT -->

                        <a
                            href="vehicles.jsp?edit=<%= rs.getInt("vehicle_id") %>"
                            class="edit">

                            Edit

                        </a>


                        <!-- DELETE -->

                        <a
                            href="VehicleServlet?action=delete&vehicle_id=<%= rs.getInt("vehicle_id") %>"
                            class="delete"
                            onclick="return confirm('Are you sure you want to delete this vehicle?');">

                            Delete

                        </a>


                    </td>


                </tr>


<%

        }


        rs.close();

        ps.close();

        con.close();


    } catch (Exception e) {

%>


                <tr>

                    <td
                        colspan="7"
                        style="color:#dc2626;text-align:center;padding:25px;">

                        Database Error:
                        <%= e.getMessage() %>

                    </td>

                </tr>


<%

    }


    if (!hasVehicles) {

%>


                <tr>

                    <td
                        colspan="7"
                        class="empty">

                        No vehicles found.

                    </td>

                </tr>


<%

    }

%>


            </tbody>


        </table>


    </div>


</div>


</body>

</html>