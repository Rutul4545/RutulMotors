<%@ page import="java.sql.*" %>
<%@ page import="Dao.DBConnection" %>

<%
    String user =
            (String) session.getAttribute("user");

    String role =
            (String) session.getAttribute("role");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("customerDashboard.jsp");
        return;
    }

    String success =
            request.getParameter("success");

    String error =
            request.getParameter("error");
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Manage Bookings | Rutul Motors</title>


<style>

* {

    margin: 0;

    padding: 0;

    box-sizing: border-box;

    font-family:
        "Segoe UI",
        Arial,
        sans-serif;
}


body {

    background: #f4f6f9;

    color: #222;

}


/* =========================
   NAVBAR
========================= */

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

    align-items: center;

    gap: 25px;

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


/* =========================
   MAIN
========================= */

.container {

    width: 92%;

    max-width: 1450px;

    margin: 45px auto;

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


/* =========================
   MESSAGE
========================= */

.success-message {

    background: #dcfce7;

    color: #166534;

    padding: 15px 20px;

    border-radius: 9px;

    margin-bottom: 25px;

    font-weight: 600;

}


.error-message {

    background: #fee2e2;

    color: #991b1b;

    padding: 15px 20px;

    border-radius: 9px;

    margin-bottom: 25px;

    font-weight: 600;

}


/* =========================
   TABLE
========================= */

.table-card {

    background: white;

    padding: 25px;

    border-radius: 16px;

    box-shadow:
        0 8px 25px
        rgba(0,0,0,0.07);

    overflow-x: auto;

}


table {

    width: 100%;

    border-collapse: collapse;

}


th {

    background: #111827;

    color: white;

    padding: 15px;

    text-align: left;

    font-size: 14px;

    white-space: nowrap;

}


td {

    padding: 15px;

    border-bottom:
        1px solid #e5e7eb;

    color: #374151;

    white-space: nowrap;

}


tr:hover {

    background: #f9fafb;

}


/* =========================
   STATUS
========================= */

.status {

    display: inline-block;

    padding: 7px 13px;

    border-radius: 20px;

    font-size: 13px;

    font-weight: 600;

}


.pending {

    background: #fff3cd;

    color: #856404;

}


.confirmed {

    background: #dcfce7;

    color: #166534;

}


.cancelled {

    background: #fee2e2;

    color: #991b1b;

}


/* =========================
   BUTTONS
========================= */

.action-form {

    display: inline;

}


.btn {

    border: none;

    padding: 8px 13px;

    border-radius: 7px;

    font-weight: 600;

    cursor: pointer;

    margin-right: 5px;

}


.confirm {

    background: #16a34a;

    color: white;

}


.confirm:hover {

    background: #15803d;

}


.cancel {

    background: #dc3545;

    color: white;

}


.cancel:hover {

    background: #b91c1c;

}


.complete {

    background: #2563eb;

    color: white;

}


.complete:hover {

    background: #1d4ed8;

}


.disabled {

    color: #9ca3af;

}


/* =========================
   EMPTY
========================= */

.empty {

    text-align: center;

    padding: 50px;

    color: #6b7280;

}


.empty h2 {

    color: #111827;

    margin-bottom: 10px;

}


/* =========================
   RESPONSIVE
========================= */

@media(max-width: 900px) {

    .navbar {

        padding: 0 20px;

    }


    .nav-links {

        gap: 10px;

    }


    .nav-links a {

        font-size: 12px;

    }


    .container {

        width: 95%;

    }

}

</style>

<link rel="stylesheet" href="polish.css">

</head>


<body>


<!-- NAVBAR -->

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


<!-- MAIN -->

<div class="container">


    <div class="header">

        <h1>
            Manage Bookings
        </h1>


        <p>

            View, confirm, cancel and complete
            customer vehicle bookings.

        </p>

    </div>


<%

if ("sale".equals(success)) {

%>


    <div class="success-message">

        Sale completed successfully.

        The sale has been added to
        Sales Management.

    </div>


<%

}


if (error != null) {

%>


    <div class="error-message">

        <%= error.replace("+", " ") %>

    </div>


<%

}

%>


    <div class="table-card">


<%

boolean found = false;


try {


    Connection con =
            DBConnection.getConnection();


    String sql =

        "SELECT b.booking_id, " +

        "b.booking_date, " +

        "b.status, " +

        "u.full_name, " +

        "u.email, " +

        "v.vehicle_name, " +

        "v.vehicle_type, " +

        "v.brand, " +

        "v.price, " +

        "s.sale_id " +

        "FROM bookings b " +

        "INNER JOIN users u " +

        "ON b.customer_id = u.user_id " +

        "INNER JOIN vehicles v " +

        "ON b.vehicle_id = v.vehicle_id " +

        "LEFT JOIN sales s " +

        "ON b.booking_id = s.booking_id " +

        "ORDER BY b.booking_id DESC";


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
                    Booking ID
                </th>

                <th>
                    Customer
                </th>

                <th>
                    Email
                </th>

                <th>
                    Vehicle
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
                    Booking Date
                </th>

                <th>
                    Status
                </th>

                <th>
                    Action
                </th>

            </tr>

            </thead>


            <tbody>


<%

        do {


            String status =
                    rs.getString("status");


            String statusClass =
                    "pending";


            if (status != null &&
                status.equalsIgnoreCase(
                    "Confirmed")) {

                statusClass =
                        "confirmed";

            }


            else if (
                status != null &&
                status.equalsIgnoreCase(
                    "Cancelled")) {

                statusClass =
                        "cancelled";
            }


            int saleId =
                    rs.getInt("sale_id");


            boolean saleExists =
                    !rs.wasNull();

%>


            <tr>


                <td>

                    #<%= rs.getInt(
                        "booking_id"
                    ) %>

                </td>


                <td>

                    <strong>

                        <%= rs.getString(
                            "full_name"
                        ) %>

                    </strong>

                </td>


                <td>

                    <%= rs.getString(
                        "email"
                    ) %>

                </td>


                <td>

                    <%= rs.getString(
                        "vehicle_name"
                    ) %>

                </td>


                <td>

                    <%= rs.getString(
                        "vehicle_type"
                    ) %>

                </td>


                <td>

                    <%= rs.getString(
                        "brand"
                    ) %>

                </td>


                <td>

                    Rs.

                    <%= String.format(
                        "%,.2f",
                        rs.getDouble("price")
                    ) %>

                </td>


                <td>

                    <%= rs.getDate(
                        "booking_date"
                    ) %>

                </td>


                <td>

                    <span
                        class="status
                        <%= statusClass %>">

                        <%= status %>

                    </span>

                </td>


                <td>


<%

/*
 * PENDING
 */

if ("Pending".equalsIgnoreCase(
        status)) {

%>


                    <form
                        action="BookingStatusServlet"
                        method="post"
                        class="action-form">


                        <input
                            type="hidden"
                            name="booking_id"
                            value="<%= rs.getInt(
                                "booking_id"
                            ) %>">


                        <input
                            type="hidden"
                            name="status"
                            value="Confirmed">


                        <button
                            type="submit"
                            class="btn confirm">

                            Confirm

                        </button>


                    </form>


                    <form
                        action="BookingStatusServlet"
                        method="post"
                        class="action-form">


                        <input
                            type="hidden"
                            name="booking_id"
                            value="<%= rs.getInt(
                                "booking_id"
                            ) %>">


                        <input
                            type="hidden"
                            name="status"
                            value="Cancelled">


                        <button
                            type="submit"
                            class="btn cancel">

                            Cancel

                        </button>


                    </form>


<%

}


/*
 * CONFIRMED + NO SALE
 */

else if (
    "Confirmed".equalsIgnoreCase(
        status)
    && !saleExists) {

%>


                    <form
                        action="CompleteSaleServlet"
                        method="post"
                        class="action-form">


                        <input
                            type="hidden"
                            name="booking_id"
                            value="<%= rs.getInt(
                                "booking_id"
                            ) %>">


                        <button
                            type="submit"
                            class="btn complete"
                            onclick="
                            return confirm(
                            'Complete this sale?'
                            );">

                            Complete Sale

                        </button>


                    </form>


<%

}


/*
 * SALE ALREADY EXISTS
 */

else if (
    "Confirmed".equalsIgnoreCase(
        status)
    && saleExists) {

%>


                    <span
                        class="disabled">

                        Sale Completed

                    </span>


<%

}


/*
 * CANCELLED
 */

else {

%>


                    <span
                        class="disabled">

                        No Action

                    </span>


<%

}

%>


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


}

catch (Exception e) {

%>


        <div class="empty">

            <h2>
                Unable to Load Bookings
            </h2>


            <p>

                <%= e.getMessage() %>

            </p>

        </div>


<%

}


if (!found) {

%>


        <div class="empty">

            <h2>
                No Bookings Found
            </h2>


            <p>

                There are currently no
                customer bookings.

            </p>

        </div>


<%

}

%>


    </div>


</div>


</body>

</html>