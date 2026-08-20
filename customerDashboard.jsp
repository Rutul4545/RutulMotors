<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="Dao.DBConnection" %>

<%
    /* =====================================================
       SESSION
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


    /* =====================================================
       CUSTOMER ID
    ===================================================== */

    Integer customerId =
            (Integer) session.getAttribute("userId");


    int totalBookings = 0;

    int pendingBookings = 0;

    int confirmedBookings = 0;


    /* =====================================================
       BOOKING STATISTICS
    ===================================================== */

    try {

        Connection con =
                DBConnection.getConnection();


        if (customerId != null) {


            /* TOTAL BOOKINGS */

            PreparedStatement ps1 =
                    con.prepareStatement(
                        "SELECT COUNT(*) " +
                        "FROM bookings " +
                        "WHERE customer_id = ?"
                    );

            ps1.setInt(
                    1,
                    customerId
            );

            ResultSet rs1 =
                    ps1.executeQuery();


            if (rs1.next()) {

                totalBookings =
                        rs1.getInt(1);
            }


            rs1.close();
            ps1.close();


            /* PENDING BOOKINGS */

            PreparedStatement ps2 =
                    con.prepareStatement(
                        "SELECT COUNT(*) " +
                        "FROM bookings " +
                        "WHERE customer_id = ? " +
                        "AND status = 'Pending'"
                    );

            ps2.setInt(
                    1,
                    customerId
            );

            ResultSet rs2 =
                    ps2.executeQuery();


            if (rs2.next()) {

                pendingBookings =
                        rs2.getInt(1);
            }


            rs2.close();
            ps2.close();


            /* CONFIRMED BOOKINGS */

            PreparedStatement ps3 =
                    con.prepareStatement(
                        "SELECT COUNT(*) " +
                        "FROM bookings " +
                        "WHERE customer_id = ? " +
                        "AND status = 'Confirmed'"
                    );

            ps3.setInt(
                    1,
                    customerId
            );

            ResultSet rs3 =
                    ps3.executeQuery();


            if (rs3.next()) {

                confirmedBookings =
                        rs3.getInt(1);
            }


            rs3.close();
            ps3.close();

        }


        con.close();


    } catch (Exception e) {

        e.printStackTrace();
    }

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Rutul Motors | Customer Dashboard
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
        }


        /* =====================================================
           HERO
        ===================================================== */

        .hero {

            width: 92%;

            max-width: 1400px;

            min-height: 330px;

            margin: 35px auto;

            border-radius: 24px;

            overflow: hidden;

            position: relative;

            background:
                linear-gradient(
                    110deg,
                    rgba(17,24,39,.96),
                    rgba(17,24,39,.78)
                ),
                url("images/trucks.jpg");

            background-size: cover;

            background-position: center;
        }


        .hero-content {

            padding: 55px;

            max-width: 720px;
        }


        .hero-label {

            color: #ff9800;

            font-size: 13px;

            font-weight: 800;

            letter-spacing: 2px;

            text-transform: uppercase;
        }


        .hero h1 {

            color: white;

            font-size: 40px;

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

            max-width: 620px;
        }


        .hero-tagline {

            display: inline-block;

            margin-top: 22px;

            padding: 10px 17px;

            border-left:
                4px solid #ff9800;

            background:
                rgba(255,255,255,.08);

            color: white;

            font-size: 13px;

            font-weight: 700;
        }


        /* =====================================================
           STATISTICS
        ===================================================== */

        .stats {

            width: 92%;

            max-width: 1400px;

            margin: 0 auto 35px;

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 20px;
        }


        .stat-card {

            background: white;

            padding: 25px;

            border-radius: 16px;

            border:
                1px solid #e5e7eb;

            box-shadow:
                0 7px 22px
                rgba(0,0,0,.05);

            transition: .25s;
        }


        .stat-card:hover {

            transform:
                translateY(-5px);

            box-shadow:
                0 15px 30px
                rgba(0,0,0,.08);
        }


        .stat-title {

            color: #64748b;

            font-size: 12px;

            font-weight: 800;

            letter-spacing: 1px;
        }


        .stat-value {

            color: #111827;

            font-size: 32px;

            font-weight: 900;

            margin-top: 10px;
        }


        .stat-card p {

            color: #94a3b8;

            font-size: 13px;

            margin-top: 5px;
        }


        .orange-border {

            border-top:
                4px solid #ff9800;
        }


        .green-border {

            border-top:
                4px solid #16a34a;
        }


        .purple-border {

            border-top:
                4px solid #7c3aed;
        }


        /* =====================================================
           VEHICLE SECTION
        ===================================================== */

        .vehicles-section {

            width: 92%;

            max-width: 1400px;

            margin: 0 auto 40px;
        }


        .section-heading {

            display: flex;

            justify-content: space-between;

            align-items: end;

            margin-bottom: 25px;
        }


        .section-heading h2 {

            font-size: 28px;

            color: #111827;
        }


        .section-heading h2 span {

            color: #ff9800;
        }


        .section-heading p {

            color: #64748b;

            font-size: 14px;

            margin-top: 6px;
        }


        .browse-link {

            color: #ff9800;

            font-size: 14px;

            font-weight: 800;
        }


        .browse-link:hover {

            text-decoration: underline;
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

            border-radius: 18px;

            overflow: hidden;

            border:
                1px solid #e5e7eb;

            box-shadow:
                0 8px 25px
                rgba(0,0,0,.05);

            transition: .3s;
        }


        .vehicle-card:hover {

            transform:
                translateY(-7px);

            box-shadow:
                0 18px 35px
                rgba(0,0,0,.10);

            border-color:
                #ff9800;
        }


        .vehicle-image {

            height: 190px;

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


        .vehicle-badge {

            position: absolute;

            top: 15px;

            left: 15px;

            background: #ff9800;

            color: #111827;

            padding: 6px 11px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: 800;
        }


        .stock-badge {

            position: absolute;

            top: 15px;

            right: 15px;

            background:
                rgba(17,24,39,.85);

            color: white;

            padding: 6px 11px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: 700;
        }


        .vehicle-content {

            padding: 23px;
        }


        .vehicle-brand {

            color: #ff9800;

            font-size: 12px;

            font-weight: 800;

            text-transform: uppercase;

            letter-spacing: 1px;
        }


        .vehicle-name {

            color: #111827;

            font-size: 21px;

            font-weight: 800;

            margin:
                7px 0 8px;
        }


        .vehicle-type {

            color: #64748b;

            font-size: 13px;

            margin-bottom: 18px;
        }


        .vehicle-bottom {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 10px;

            padding-top: 16px;

            border-top:
                1px solid #edf0f4;
        }


        .vehicle-price {

            color: #111827;

            font-size: 19px;

            font-weight: 900;
        }


        .vehicle-price small {

            display: block;

            color: #94a3b8;

            font-size: 10px;

            font-weight: 500;
        }


        .book-btn {

            background:
                linear-gradient(
                    135deg,
                    #ff9800,
                    #ff7a00
                );

            color: white;

            padding: 10px 15px;

            border-radius: 8px;

            font-size: 12px;

            font-weight: 800;

            transition: .25s;
        }


        .book-btn:hover {

            transform:
                translateY(-2px);

            box-shadow:
                0 7px 15px
                rgba(255,152,0,.25);
        }


        .out-stock {

            background: #e5e7eb;

            color: #64748b;

            padding: 10px 15px;

            border-radius: 8px;

            font-size: 12px;

            font-weight: 700;
        }


        /* =====================================================
           TAGLINE
        ===================================================== */

        .tagline {

            width: 92%;

            max-width: 1400px;

            margin: 0 auto 35px;

            background:
                linear-gradient(
                    135deg,
                    #ff9800,
                    #ff7a00
                );

            color: white;

            padding: 20px;

            border-radius: 13px;

            text-align: center;

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


        @media(max-width:750px) {

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

                gap: 15px;
            }


            .hero-content {

                padding: 40px 30px;
            }


            .hero h1 {

                font-size: 31px;
            }


            .stats {

                grid-template-columns:
                    1fr;
            }


            .vehicle-grid {

                grid-template-columns:
                    1fr;
            }


            .section-heading {

                align-items:
                    flex-start;

                flex-direction:
                    column;

                gap: 10px;
            }

        }


        @media(max-width:500px) {

            .hero {

                width: 94%;

                min-height: 300px;
            }


            .hero-content {

                padding:
                    35px 25px;
            }


            .hero h1 {

                font-size: 27px;
            }


            .vehicle-image {

                height: 210px;
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


        <a href="customerDashboard.jsp"
           class="active">

            Dashboard

        </a>


        <!-- CUSTOMER VEHICLES -->

        <a href="customerVehicles.jsp">

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

            Welcome to Rutul Motors

        </div>


        <h1>

            Welcome,

            <span>
                <%= fullName != null
                    ? fullName
                    : user %>
            </span>

        </h1>


        <p>

            Find reliable commercial and heavy
            vehicles for your business.
            Browse our collection and book
            the vehicle that fits your requirements.

        </p>


        <div class="hero-tagline">

            Rutul Motors build to move forward

        </div>


    </div>

</section>



<!-- =====================================================
     CUSTOMER STATISTICS
===================================================== -->

<section class="stats">


    <div class="stat-card orange-border">

        <div class="stat-title">

            TOTAL BOOKINGS

        </div>


        <div class="stat-value">

            <%= totalBookings %>

        </div>


        <p>

            Your vehicle bookings

        </p>

    </div>



    <div class="stat-card purple-border">

        <div class="stat-title">

            PENDING

        </div>


        <div class="stat-value">

            <%= pendingBookings %>

        </div>


        <p>

            Awaiting confirmation

        </p>

    </div>



    <div class="stat-card green-border">

        <div class="stat-title">

            CONFIRMED

        </div>


        <div class="stat-value">

            <%= confirmedBookings %>

        </div>


        <p>

            Confirmed bookings

        </p>

    </div>


</section>



<!-- =====================================================
     VEHICLES SECTION
===================================================== -->

<section class="vehicles-section">


    <div class="section-heading">


        <div>

            <h2>

                Explore Our
                <span>Vehicles</span>

            </h2>


            <p>

                Choose from our available
                commercial vehicles.

            </p>

        </div>


        <!-- IMPORTANT:
             CUSTOMER GOES TO CUSTOMER VEHICLES
             NOT ADMIN VEHICLES
        -->

        <a href="customerVehicles.jsp"
           class="browse-link">

            View All Vehicles →

        </a>


    </div>



    <!-- =================================================
         VEHICLE GRID
    ================================================= -->

    <div class="vehicle-grid">


<%

    Connection con = null;

    PreparedStatement vehiclePs = null;

    ResultSet vehicleRs = null;

    int count = 0;


    try {

        con =
                DBConnection.getConnection();


        vehiclePs =
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


        vehicleRs =
                vehiclePs.executeQuery();


        while (vehicleRs.next()
                && count < 6) {


            int vehicleId =
                    vehicleRs.getInt(
                        "vehicle_id"
                    );


            String vehicleName =
                    vehicleRs.getString(
                        "vehicle_name"
                    );


            String vehicleType =
                    vehicleRs.getString(
                        "vehicle_type"
                    );


            String brand =
                    vehicleRs.getString(
                        "brand"
                    );


            double price =
                    vehicleRs.getDouble(
                        "price"
                    );


            int stock =
                    vehicleRs.getInt(
                        "stock"
                    );


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


        <!-- VEHICLE CARD -->

        <div class="vehicle-card">


            <div class="vehicle-image">


                <div class="vehicle-badge">

                    <%= brand != null
                        ? brand
                        : "Vehicle" %>

                </div>


                <div class="stock-badge">

                    <%= stock > 0
                        ? stock + " Available"
                        : "Out of Stock" %>

                </div>


            </div>


            <div class="vehicle-content">


                <div class="vehicle-brand">

                    <%= brand != null
                        ? brand
                        : "Rutul Motors" %>

                </div>


                <div class="vehicle-name">

                    <%= vehicleName %>

                </div>


                <div class="vehicle-type">

                    <%= vehicleType != null
                        ? vehicleType
                        : "Commercial Vehicle" %>

                </div>


                <div class="vehicle-bottom">


                    <div class="vehicle-price">

                        ₹<%= formattedPrice %>

                        <small>
                            Starting Price
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

            count++;

        }


    } catch (Exception e) {

        e.printStackTrace();

    } finally {


        try {

            if (vehicleRs != null)
                vehicleRs.close();

        } catch (Exception ignored) {}


        try {

            if (vehiclePs != null)
                vehiclePs.close();

        } catch (Exception ignored) {}


        try {

            if (con != null)
                con.close();

        } catch (Exception ignored) {}

    }


%>


    </div>

</section>



<!-- =====================================================
     TAGLINE
===================================================== -->

<div class="tagline">

    Rutul Motors — Build to Move Forward

</div>


</body>

</html>