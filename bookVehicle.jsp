<%@ page import="java.sql.*" %>
<%@ page import="Dao.DBConnection" %>

<%
    String user = (String) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Book Vehicle | Rutul Motors</title>

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

            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);
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
            max-width: 1250px;
            margin: 40px auto;
        }

        /* HEADER */

        .page-header {
            margin-bottom: 35px;
        }

        .page-header h1 {
            font-size: 32px;
            color: #111827;
            margin-bottom: 8px;
        }

        .page-header p {
            color: #6b7280;
            font-size: 15px;
        }

        /* USER MESSAGE */

        .welcome {
            background: white;
            padding: 18px 22px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #ff9800;

            box-shadow: 0 5px 18px rgba(0, 0, 0, 0.05);
        }

        .welcome strong {
            color: #111827;
        }

        /* VEHICLE GRID */

        .vehicle-grid {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 25px;
        }

        /* VEHICLE CARD */

        .vehicle-card {
            background: white;

            border-radius: 16px;

            padding: 27px;

            box-shadow:
                0 8px 25px rgba(0, 0, 0, 0.07);

            transition: 0.3s;

            border-top: 4px solid #ff9800;
        }

        .vehicle-card:hover {
            transform: translateY(-5px);

            box-shadow:
                0 14px 30px rgba(0, 0, 0, 0.12);
        }

        .vehicle-name {
            font-size: 21px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 18px;
        }

        .info {
            margin-bottom: 10px;
            color: #6b7280;
            font-size: 14px;
        }

        .info strong {
            color: #374151;
        }

        .price {
            font-size: 22px;
            font-weight: 700;
            color: #ff8c00;
            margin: 18px 0;
        }

        .stock {
            font-weight: 600;
            margin-bottom: 18px;
            font-size: 14px;
        }

        .available {
            color: #16a34a;
        }

        .out {
            color: #dc2626;
        }

        /* BOOK BUTTON */

        .book-btn {
            width: 100%;

            padding: 13px;

            border: none;

            border-radius: 9px;

            background: #ff9800;

            color: #111827;

            font-size: 15px;

            font-weight: 700;

            cursor: pointer;

            transition: 0.3s;
        }

        .book-btn:hover {
            background: #ffb300;

            transform: translateY(-1px);
        }

        .disabled-btn {
            background: #d1d5db;

            color: #6b7280;

            cursor: not-allowed;
        }

        .disabled-btn:hover {
            background: #d1d5db;

            transform: none;
        }

        /* ERROR */

        .error-box {
            grid-column: 1 / -1;

            background: #fee2e2;

            color: #991b1b;

            padding: 20px;

            border-radius: 10px;

            border-left: 4px solid #dc2626;
        }

        /* EMPTY */

        .empty-box {
            grid-column: 1 / -1;

            background: white;

            text-align: center;

            padding: 50px;

            border-radius: 15px;

            color: #6b7280;

            box-shadow:
                0 8px 25px rgba(0, 0, 0, 0.07);
        }

        /* RESPONSIVE */

        @media (max-width: 1000px) {

            .vehicle-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }
        }

        @media (max-width: 650px) {

            .navbar {
                padding: 0 20px;
            }

            .nav-links {
                gap: 10px;
            }

            .nav-links a {
                font-size: 13px;
            }

            .vehicle-grid {
                grid-template-columns: 1fr;
            }

            .container {
                width: 94%;
            }
        }

    </style>

    <link rel="stylesheet" href="polish.css">

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

        <a href="bookVehicle.jsp">
            Book Vehicle
        </a>

        <a href="about.jsp">
            About Us
        </a>

        <a href="logout">
            Logout
        </a>

    </div>

</div>


<!-- MAIN CONTENT -->

<div class="container">


    <!-- PAGE HEADER -->

    <div class="page-header">

        <h1>
            Book a Vehicle
        </h1>

        <p>
            Select a commercial vehicle and submit
            your booking request.
        </p>

    </div>


    <!-- LOGGED-IN USER -->

    <div class="welcome">

        Welcome,
        <strong>
            <%= user %>
        </strong>

        <br>

        Select a vehicle below to create a booking.

    </div>


    <!-- VEHICLE CARDS -->

    <div class="vehicle-grid">


<%

    boolean found = false;

    try {

        Connection con =
            DBConnection.getConnection();


        String sql =
            "SELECT vehicle_id, vehicle_name, " +
            "vehicle_type, brand, price, stock " +
            "FROM vehicles " +
            "ORDER BY vehicle_id DESC";


        PreparedStatement ps =
            con.prepareStatement(sql);


        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

            found = true;

            int vehicleId =
                rs.getInt("vehicle_id");

            int stock =
                rs.getInt("stock");

%>


        <!-- VEHICLE CARD -->

        <div class="vehicle-card">


            <div class="vehicle-name">

                <%= rs.getString("vehicle_name") %>

            </div>


            <div class="info">

                Vehicle Type:

                <strong>
                    <%= rs.getString("vehicle_type") %>
                </strong>

            </div>


            <div class="info">

                Brand:

                <strong>
                    <%= rs.getString("brand") %>
                </strong>

            </div>


            <div class="price">

                Rs.
                <%= String.format(
                    "%,.2f",
                    rs.getDouble("price")
                ) %>

            </div>


            <% if (stock > 0) { %>


                <div class="stock available">

                    Stock Available:
                    <%= stock %>

                </div>


                <form
                    action="BookingServlet"
                    method="post">


                    <input
                        type="hidden"
                        name="vehicle_id"
                        value="<%= vehicleId %>">


                    <button
                        type="submit"
                        class="book-btn">

                        Book Vehicle

                    </button>


                </form>


            <% } else { %>


                <div class="stock out">

                    Out of Stock

                </div>


                <button
                    type="button"
                    class="book-btn disabled-btn"
                    disabled>

                    Currently Unavailable

                </button>


            <% } %>


        </div>


<%

        }


        rs.close();

        ps.close();

        con.close();


    } catch (Exception e) {

%>


        <div class="error-box">

            <strong>
                Database Error
            </strong>

            <br><br>

            <%= e.getMessage() %>

        </div>


<%

    }


    if (!found) {

%>


        <div class="empty-box">

            <h2>
                No Vehicles Available
            </h2>

            <br>

            <p>
                There are currently no vehicles
                available for booking.
            </p>

        </div>


<%

    }

%>


    </div>


</div>


</body>

</html>