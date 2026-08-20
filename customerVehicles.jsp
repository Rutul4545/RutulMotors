<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="Dao.DBConnection" %>

<%
    /* =====================================================
       CUSTOMER SESSION
    ===================================================== */

    String user =
            (String) session.getAttribute("user");

    String fullName =
            (String) session.getAttribute("fullName");

    String role =
            (String) session.getAttribute("role");


    /* =====================================================
       LOGIN CHECK
    ===================================================== */

    if (user == null) {

        response.sendRedirect("login.html");

        return;
    }


    /* =====================================================
       CUSTOMER CHECK
    ===================================================== */

    if (!"CUSTOMER".equalsIgnoreCase(role)) {

        response.sendRedirect("dashboard.jsp");

        return;
    }

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Vehicles | Rutul Motors
    </title>


    <style>

        /* =====================================================
           RESET
        ===================================================== */

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

            color: #111827;
        }


        a {

            text-decoration: none;
        }


        /* =====================================================
           NAVBAR
        ===================================================== */

        .navbar {

            height: 72px;

            background: #111827;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 6%;

            position: sticky;

            top: 0;

            z-index: 1000;

            box-shadow:
                0 5px 20px
                rgba(0,0,0,.15);
        }


        .logo {

            color: white;

            font-size: 25px;

            font-weight: 900;

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

            color: #d1d5db;

            font-size: 14px;

            font-weight: 600;

            transition: .25s;
        }


        .nav-links a:hover {

            color: #ff9800;
        }


        .nav-links .active {

            color: #ff9800;
        }


        .logout {

            background: #dc3545;

            color: white !important;

            padding: 10px 18px;

            border-radius: 8px;
        }


        .logout:hover {

            background: #b91c1c;

            color: white !important;
        }


        /* =====================================================
           HERO
        ===================================================== */

        .hero {

            width: 92%;

            max-width: 1400px;

            min-height: 290px;

            margin: 35px auto;

            border-radius: 24px;

            overflow: hidden;

            position: relative;

            background:
                linear-gradient(
                    110deg,
                    rgba(17,24,39,.95),
                    rgba(17,24,39,.72)
                ),
                url("images/trucks.jpg");

            background-size: cover;

            background-position: center;

            display: flex;

            align-items: center;
        }


        .hero-content {

            padding: 50px;

            max-width: 720px;
        }


        .hero-label {

            color: #ff9800;

            font-size: 13px;

            font-weight: 800;

            text-transform: uppercase;

            letter-spacing: 2px;
        }


        .hero h1 {

            color: white;

            font-size: 42px;

            margin:
                10px 0 15px;
        }


        .hero h1 span {

            color: #ff9800;
        }


        .hero p {

            color: #d1d5db;

            font-size: 16px;

            line-height: 1.7;
        }


        .hero-tagline {

            display: inline-block;

            margin-top: 20px;

            padding: 9px 17px;

            border-left:
                4px solid #ff9800;

            background:
                rgba(255,255,255,.08);

            color: white;

            font-size: 13px;

            font-weight: 700;
        }


        /* =====================================================
           MAIN SECTION
        ===================================================== */

        .container {

            width: 92%;

            max-width: 1400px;

            margin: 0 auto 50px;
        }


        .section-heading {

            display: flex;

            justify-content: space-between;

            align-items: end;

            margin-bottom: 28px;
        }


        .section-heading h2 {

            color: #111827;

            font-size: 30px;
        }


        .section-heading h2 span {

            color: #ff9800;
        }


        .section-heading p {

            color: #64748b;

            margin-top: 6px;

            font-size: 14px;
        }


        .back-dashboard {

            color: #ff9800;

            font-size: 13px;

            font-weight: 800;
        }


        /* =====================================================
           VEHICLE GRID
        ===================================================== */

        .vehicle-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 25px;
        }


        /* =====================================================
           VEHICLE CARD
        ===================================================== */

        .vehicle-card {

            background: white;

            border-radius: 20px;

            overflow: hidden;

            border:
                1px solid #e5e7eb;

            box-shadow:
                0 8px 25px
                rgba(0,0,0,.05);

            transition:
                .3s;

            position: relative;
        }


        .vehicle-card:hover {

            transform:
                translateY(-7px);

            border-color:
                #ff9800;

            box-shadow:
                0 18px 35px
                rgba(0,0,0,.10);
        }


        /* =====================================================
           VEHICLE IMAGE
        ===================================================== */

        .vehicle-image {

            height: 215px;

            background:
                linear-gradient(
                    rgba(17,24,39,.25),
                    rgba(17,24,39,.35)
                ),
                url("images/trucks.jpg");

            background-size: cover;

            background-position: center;

            position: relative;
        }


        .brand-badge {

            position: absolute;

            top: 15px;

            left: 15px;

            background: #ff9800;

            color: #111827;

            padding: 7px 13px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: 800;

            text-transform: uppercase;
        }


        .stock-badge {

            position: absolute;

            top: 15px;

            right: 15px;

            padding: 7px 13px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: 800;

            background:
                rgba(17,24,39,.88);

            color: white;
        }


        /* =====================================================
           CARD CONTENT
        ===================================================== */

        .vehicle-content {

            padding: 24px;
        }


        .vehicle-type {

            color: #ff9800;

            font-size: 11px;

            text-transform: uppercase;

            letter-spacing: 1.2px;

            font-weight: 800;

            margin-bottom: 7px;
        }


        .vehicle-name {

            color: #111827;

            font-size: 22px;

            font-weight: 900;

            margin-bottom: 8px;
        }


        .vehicle-description {

            color: #64748b;

            font-size: 13px;

            line-height: 1.6;

            min-height: 42px;
        }


        /* =====================================================
           CARD BOTTOM
        ===================================================== */

        .vehicle-footer {

            margin-top: 20px;

            padding-top: 18px;

            border-top:
                1px solid #edf0f4;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;
        }


        .price {

            color: #111827;

            font-size: 20px;

            font-weight: 900;
        }


        .price small {

            display: block;

            color: #94a3b8;

            font-size: 10px;

            font-weight: 500;

            margin-top: 2px;
        }


        /* =====================================================
           BOOK BUTTON
        ===================================================== */

        .book-btn {

            background:
                linear-gradient(
                    135deg,
                    #ff9800,
                    #ff7a00
                );

            color: white;

            padding:
                11px 17px;

            border-radius: 9px;

            font-size: 12px;

            font-weight: 800;

            transition: .25s;

            white-space: nowrap;
        }


        .book-btn:hover {

            transform:
                translateY(-2px);

            box-shadow:
                0 8px 18px
                rgba(255,152,0,.25);
        }


        /* =====================================================
           OUT OF STOCK
        ===================================================== */

        .out-stock {

            background: #e5e7eb;

            color: #64748b;

            padding:
                11px 17px;

            border-radius: 9px;

            font-size: 12px;

            font-weight: 800;
        }


        /* =====================================================
           NO VEHICLES
        ===================================================== */

        .empty-box {

            grid-column: 1 / -1;

            background: white;

            padding: 70px 30px;

            border-radius: 20px;

            text-align: center;

            border:
                1px solid #e5e7eb;

            box-shadow:
                0 8px 25px
                rgba(0,0,0,.05);
        }


        .empty-box h2 {

            color: #111827;

            margin-bottom: 10px;
        }


        .empty-box p {

            color: #64748b;
        }


        /* =====================================================
           BOTTOM TAGLINE
        ===================================================== */

        .tagline {

            margin-top: 40px;

            background:
                linear-gradient(
                    135deg,
                    #ff9800,
                    #ff7a00
                );

            color: white;

            text-align: center;

            padding: 20px;

            border-radius: 14px;

            font-size: 18px;

            font-weight: 800;

            box-shadow:
                0 8px 20px
                rgba(255,152,0,.2);
        }


        /* =====================================================
           RESPONSIVE
        ===================================================== */

        @media(max-width:1000px) {

            .vehicle-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }

        }


        @media(max-width:700px) {

            .navbar {

                height: auto;

                padding:
                    18px 25px;

                flex-direction:
                    column;

                gap: 15px;
            }


            .nav-links {

                flex-wrap: wrap;

                justify-content:
                    center;

                gap: 14px;
            }


            .hero {

                width: 94%;
            }


            .hero-content {

                padding:
                    40px 25px;
            }


            .hero h1 {

                font-size: 31px;
            }


            .container {

                width: 94%;
            }


            .vehicle-grid {

                grid-template-columns: 1fr;
            }


            .section-heading {

                align-items:
                    flex-start;

                flex-direction:
                    column;

                gap: 10px;
            }

        }


    </style>

</head>


<body>


<!-- =====================================================
     NAVBAR
===================================================== -->


<nav class="navbar">


    <div class="logo">

        RUTUL <span>MOTORS</span>

    </div>


    <div class="nav-links">


        <a href="customerDashboard.jsp">

            Dashboard

        </a>


        <a href="customerVehicles.jsp"
           class="active">

            Vehicles

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


</nav>



<!-- =====================================================
     HERO
===================================================== -->


<section class="hero">


    <div class="hero-content">


        <div class="hero-label">

            Rutul Motors

        </div>


        <h1>

            Find Your
            <span>Perfect Vehicle</span>

        </h1>


        <p>

            Explore our collection of commercial
            and heavy vehicles designed to support
            your business and keep you moving.

        </p>


        <div class="hero-tagline">

            Rutul Motors build to move forward

        </div>


    </div>


</section>



<!-- =====================================================
     VEHICLES
===================================================== -->


<div class="container">


    <div class="section-heading">


        <div>

            <h2>

                Available
                <span>Vehicles</span>

            </h2>


            <p>

                Choose a vehicle that matches
                your business requirements.

            </p>

        </div>


        <a
            href="customerDashboard.jsp"
            class="back-dashboard">

            ← Dashboard

        </a>


    </div>



    <!-- =================================================
         VEHICLE GRID
    ================================================= -->


    <div class="vehicle-grid">


<%

    /* =====================================================
       DATABASE
    ===================================================== */

    Connection con = null;

    PreparedStatement ps = null;

    ResultSet rs = null;


    int vehicleCount = 0;


    try {

        con =
                DBConnection.getConnection();


        ps =
                con.prepareStatement(
                    "SELECT vehicle_id, " +
                    "vehicle_name, " +
                    "vehicle_type, " +
                    "brand, " +
                    "price, " +
                    "stock " +
                    "FROM vehicles " +
                    "ORDER BY vehicle_id DESC"
                );


        rs =
                ps.executeQuery();


        while (rs.next()) {


            vehicleCount++;


            int vehicleId =
                    rs.getInt(
                        "vehicle_id"
                    );


            String vehicleName =
                    rs.getString(
                        "vehicle_name"
                    );


            String vehicleType =
                    rs.getString(
                        "vehicle_type"
                    );


            String brand =
                    rs.getString(
                        "brand"
                    );


            double price =
                    rs.getDouble(
                        "price"
                    );


            int stock =
                    rs.getInt(
                        "stock"
                    );


            /* =========================================
               INDIAN PRICE FORMAT
            ========================================= */

            java.text.DecimalFormat
                    indianFormat =
                    new java.text.DecimalFormat(
                        "#,##,##0"
                    );


            String formattedPrice =
                    indianFormat.format(
                        price
                    );

%>


        <!-- =================================================
             VEHICLE CARD
        ================================================= -->


        <div class="vehicle-card">


            <!-- IMAGE -->

            <div class="vehicle-image">


                <div class="brand-badge">

                    <%= brand != null
                        ? brand
                        : "Rutul Motors" %>

                </div>


                <div class="stock-badge">

                    <%= stock > 0
                        ? stock + " Available"
                        : "Out of Stock" %>

                </div>


            </div>



            <!-- CONTENT -->

            <div class="vehicle-content">


                <div class="vehicle-type">

                    <%= vehicleType != null
                        ? vehicleType
                        : "Commercial Vehicle" %>

                </div>


                <div class="vehicle-name">

                    <%= vehicleName %>

                </div>


                <div class="vehicle-description">

                    Reliable commercial vehicle
                    suitable for business and
                    transportation requirements.

                </div>


                <!-- FOOTER -->

                <div class="vehicle-footer">


                    <div class="price">

                        ₹<%= formattedPrice %>

                        <small>
                            Vehicle Price
                        </small>

                    </div>


                    <% if (stock > 0) { %>


                        <a
                            href="bookVehicle.jsp?vehicle_id=<%= vehicleId %>"
                            class="book-btn">

                            Book Now

                        </a>


                    <% } else { %>


                        <span class="out-stock">

                            Out of Stock

                        </span>


                    <% } %>


                </div>


            </div>


        </div>


<%

        }


        /* =================================================
           NO VEHICLES
        ================================================= */

        if (vehicleCount == 0) {

%>


        <div class="empty-box">


            <h2>

                No Vehicles Available

            </h2>


            <p>

                There are currently no vehicles
                available for booking.

                Please check again later.

            </p>


        </div>


<%

        }


    } catch (Exception e) {

        e.printStackTrace();

%>


        <div class="empty-box">


            <h2>

                Unable to Load Vehicles

            </h2>


            <p>

                Please try again later.

            </p>


        </div>


<%

    } finally {


        try {

            if (rs != null)
                rs.close();

        } catch (Exception ignored) {}


        try {

            if (ps != null)
                ps.close();

        } catch (Exception ignored) {}


        try {

            if (con != null)
                con.close();

        } catch (Exception ignored) {}

    }

%>


    </div>



    <!-- =================================================
         TAGLINE
    ================================================= -->


    <div class="tagline">

        Rutul Motors — Build to Move Forward

    </div>


</div>


</body>

</html>