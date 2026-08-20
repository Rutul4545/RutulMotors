<%@ page import="java.sql.*" %>
<%@ page import="Dao.DBConnection" %>

<%
    String user = (String) session.getAttribute("user");
    String fullName = (String) session.getAttribute("fullName");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }

    Object userIdObject = session.getAttribute("userId");

    if (userIdObject == null) {
        response.sendRedirect("login.html");
        return;
    }

    int customerId = (Integer) userIdObject;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Bookings | Rutul Motors</title>

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
        }

        .nav-links a:hover {
            color: #ff9800;
        }

        .logout {
            background: #dc3545;
            padding: 9px 17px;
            border-radius: 7px;
        }

        .logout:hover {
            color: white !important;
        }

        /* CONTAINER */

        .container {
            width: 92%;
            max-width: 1200px;
            margin: 45px auto;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 32px;
            color: #111827;
            margin-bottom: 8px;
        }

        .page-header p {
            color: #6b7280;
        }

        /* TABLE CARD */

        .table-card {
            background: white;
            border-radius: 16px;

            padding: 25px;

            box-shadow:
                0 8px 25px rgba(0,0,0,0.07);

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
        }

        td {
            padding: 15px;

            border-bottom:
                1px solid #e5e7eb;

            color: #374151;
        }

        tr:hover {
            background: #f9fafb;
        }

        /* STATUS */

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

        /* EMPTY */

        .empty {
            text-align: center;

            padding: 60px 20px;

            color: #6b7280;
        }

        .empty h2 {
            color: #111827;
            margin-bottom: 10px;
        }

        .browse-btn {
            display: inline-block;

            margin-top: 20px;

            padding: 12px 22px;

            background: #ff9800;

            color: #111827;

            text-decoration: none;

            border-radius: 8px;

            font-weight: 700;
        }

        .browse-btn:hover {
            background: #ffb300;
        }

        /* RESPONSIVE */

        @media(max-width: 700px) {

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

</head>


<body>


<!-- NAVBAR -->

<div class="navbar">

    <div class="logo">

        RUTUL <span>MOTORS</span>

    </div>


    <div class="nav-links">

        <a href="customerDashboard.jsp">
            Dashboard
        </a>

        <a href="bookVehicle.jsp">
            Browse Vehicles
        </a>

        <a href="myBookings.jsp">
            My Bookings
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


    <div class="page-header">

        <h1>
            My Bookings
        </h1>

        <p>
            View your vehicle booking history
            and current booking status.
        </p>

    </div>


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
                "v.vehicle_name, " +
                "v.vehicle_type, " +
                "v.brand, " +
                "v.price " +
                "FROM bookings b " +
                "INNER JOIN vehicles v " +
                "ON b.vehicle_id = v.vehicle_id " +
                "WHERE b.customer_id = ? " +
                "ORDER BY b.booking_id DESC";


        PreparedStatement ps =
                con.prepareStatement(sql);


        ps.setInt(1, customerId);


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
                    status.equalsIgnoreCase("Confirmed")) {

                    statusClass =
                            "confirmed";

                } else if (
                    status != null &&
                    status.equalsIgnoreCase("Cancelled")) {

                    statusClass =
                            "cancelled";
                }

%>


                <tr>

                    <td>

                        #<%= rs.getInt("booking_id") %>

                    </td>


                    <td>

                        <strong>

                            <%= rs.getString(
                                "vehicle_name"
                            ) %>

                        </strong>

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

                        <span class="status <%= statusClass %>">

                            <%= status %>

                        </span>

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


        <div class="empty">

            <h2>
                Unable to load bookings
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
                No Bookings Yet
            </h2>

            <p>
                You haven't booked any vehicles yet.
            </p>


            <a href="bookVehicle.jsp"
               class="browse-btn">

                Browse Vehicles

            </a>

        </div>


<%

    }

%>


    </div>


</div>


</body>

</html>