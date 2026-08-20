<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="Dao.DBConnection" %>

<%
    String user = (String) session.getAttribute("user");
    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("customerDashboard.jsp");
        return;
    }

    int vehicleCount = 0;
    int salesCount = 0;
    int bookingCount = 0;
    int pendingBookings = 0;
    int confirmedBookings = 0;
    double totalRevenue = 0.0;

    try {

        Connection con = DBConnection.getConnection();

        PreparedStatement ps1 =
            con.prepareStatement(
                "SELECT COALESCE(SUM(stock), 0) FROM vehicles"
            );

        ResultSet rs1 = ps1.executeQuery();

        if (rs1.next()) {
            vehicleCount = rs1.getInt(1);
        }

        rs1.close();
        ps1.close();


        PreparedStatement ps2 =
            con.prepareStatement(
                "SELECT COUNT(*) FROM sales"
            );

        ResultSet rs2 = ps2.executeQuery();

        if (rs2.next()) {
            salesCount = rs2.getInt(1);
        }

        rs2.close();
        ps2.close();


        PreparedStatement ps3 =
            con.prepareStatement(
                "SELECT COALESCE(SUM(amount),0) FROM sales"
            );

        ResultSet rs3 = ps3.executeQuery();

        if (rs3.next()) {
            totalRevenue = rs3.getDouble(1);
        }

        rs3.close();
        ps3.close();


        PreparedStatement ps4 =
            con.prepareStatement(
                "SELECT COUNT(*) FROM bookings"
            );

        ResultSet rs4 = ps4.executeQuery();

        if (rs4.next()) {
            bookingCount = rs4.getInt(1);
        }

        rs4.close();
        ps4.close();


        PreparedStatement ps5 =
            con.prepareStatement(
                "SELECT COUNT(*) FROM bookings WHERE status='Pending'"
            );

        ResultSet rs5 = ps5.executeQuery();

        if (rs5.next()) {
            pendingBookings = rs5.getInt(1);
        }

        rs5.close();
        ps5.close();


        PreparedStatement ps6 =
            con.prepareStatement(
                "SELECT COUNT(*) FROM bookings WHERE status='Confirmed'"
            );

        ResultSet rs6 = ps6.executeQuery();

        if (rs6.next()) {
            confirmedBookings = rs6.getInt(1);
        }

        rs6.close();
        ps6.close();

        con.close();

    } catch (Exception e) {
        e.printStackTrace();
    }


    long revenueValue = Math.round(totalRevenue);

    String revenueString = String.valueOf(revenueValue);

    String formattedRevenue;

    if (revenueString.length() <= 3) {

        formattedRevenue = revenueString;

    } else {

        String lastThree =
            revenueString.substring(
                revenueString.length() - 3
            );

        String remaining =
            revenueString.substring(
                0,
                revenueString.length() - 3
            );

        StringBuilder result =
            new StringBuilder();

        int firstGroup =
            remaining.length() % 2;

        if (firstGroup > 0) {

            result.append(
                remaining.substring(
                    0,
                    firstGroup
                )
            );

            if (remaining.length() > firstGroup) {
                result.append(",");
            }
        }

        for (
            int i = firstGroup;
            i < remaining.length();
            i += 2
        ) {

            result.append(
                remaining.substring(
                    i,
                    i + 2
                )
            );

            if (i + 2 < remaining.length()) {
                result.append(",");
            }
        }

        result.append(",");
        result.append(lastThree);

        formattedRevenue =
            result.toString();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Rutul Motors | Admin Dashboard</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Segoe UI", Arial, sans-serif;
}

body {
    background: #f3f5f8;
    color: #111827;
}

a {
    text-decoration: none;
}

.sidebar {
    position: fixed;
    left: 0;
    top: 0;
    width: 270px;
    height: 100vh;
    background:
        linear-gradient(
            180deg,
            #0b1220,
            #151f32
        );
    color: white;
    padding: 30px 20px;
    z-index: 100;
    box-shadow:
        5px 0 25px
        rgba(0,0,0,.12);
}

.logo {
    padding: 5px 15px 35px;
    border-bottom:
        1px solid
        rgba(255,255,255,.08);
    margin-bottom: 30px;
}

.logo h1 {
    font-size: 27px;
    letter-spacing: 1px;
    font-weight: 900;
}

.logo h1 span {
    color: #ff9800;
}

.logo p {
    color: #8f9bad;
    font-size: 11px;
    margin-top: 7px;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}

.menu-title {
    color: #69778c;
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    margin: 25px 12px 12px;
}

.menu {
    list-style: none;
}

.menu li {
    margin-bottom: 6px;
}

.menu a {
    display: flex;
    align-items: center;
    gap: 13px;
    padding: 13px 15px;
    color: #cbd5e1;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 500;
    transition: .25s;
}

.menu a:hover {
    background:
        rgba(255,152,0,.1);
    color: #ff9800;
    transform:
        translateX(3px);
}

.menu a.active {
    background:
        linear-gradient(
            135deg,
            #ff9800,
            #ff7a00
        );
    color: #111827;
    font-weight: 800;
    box-shadow:
        0 8px 18px
        rgba(255,152,0,.2);
}

.menu-icon {
    width: 27px;
    height: 27px;
    border-radius: 7px;
    display: flex;
    align-items: center;
    justify-content: center;
    background:
        rgba(255,255,255,.06);
    font-size: 13px;
    font-weight: 800;
}

.active .menu-icon {
    background:
        rgba(17,24,39,.12);
}

.logout {
    margin-top: 25px;
    background:
        rgba(220,53,69,.08);
}

.logout:hover {
    background:
        rgba(220,53,69,.18) !important;
    color: #ff6b7a !important;
}

.main {
    margin-left: 270px;
    padding: 30px 40px 50px;
    min-height: 100vh;
}

.topbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 25px;
}

.welcome small {
    color: #ff9800;
    font-weight: 800;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 1.5px;
}

.welcome h1 {
    font-size: 31px;
    color: #111827;
    margin-top: 5px;
}

.welcome p {
    color: #64748b;
    font-size: 14px;
    margin-top: 5px;
}

.welcome strong {
    color: #111827;
}

.top-actions {
    display: flex;
    align-items: center;
    gap: 15px;
}

.date-box {
    background: white;
    border:
        1px solid #e5e7eb;
    padding: 11px 16px;
    border-radius: 10px;
    color: #64748b;
    font-size: 13px;
}

.logout-btn {
    background: #dc3545;
    color: white;
    padding: 11px 20px;
    border-radius: 9px;
    font-size: 13px;
    font-weight: 700;
    transition: .25s;
}

.logout-btn:hover {
    background: #b91c1c;
    transform:
        translateY(-2px);
}

.hero-banner {
    position: relative;
    min-height: 205px;
    border-radius: 20px;
    overflow: hidden;
    margin-bottom: 28px;
    background:
        linear-gradient(
            110deg,
            #111827,
            #1b2940
        );
    box-shadow:
        0 15px 35px
        rgba(15,23,42,.12);
}

.hero-banner::after {
    content: "";
    position: absolute;
    width: 450px;
    height: 450px;
    right: -150px;
    top: -220px;
    border-radius: 50%;
    background:
        rgba(255,152,0,.15);
}

.hero-content {
    position: relative;
    z-index: 2;
    padding: 38px 40px;
}

.hero-content .label {
    color: #ff9800;
    font-size: 12px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 2px;
}

.hero-content h2 {
    color: white;
    font-size: 30px;
    margin:
        8px 0 10px;
}

.hero-content h2 span {
    color: #ff9800;
}

.hero-content p {
    color: #cbd5e1;
    font-size: 14px;
    max-width: 620px;
    line-height: 1.7;
}

.hero-tagline {
    display: inline-block;
    margin-top: 18px;
    padding: 8px 15px;
    border-left:
        3px solid #ff9800;
    background:
        rgba(255,255,255,.06);
    color: #e5e7eb;
    font-size: 12px;
    font-weight: 600;
}

.stats {
    display: grid;
    grid-template-columns:
        repeat(4, 1fr);
    gap: 18px;
    margin-bottom: 28px;
}

.stat-card {
    background: white;
    border-radius: 16px;
    padding: 23px;
    border:
        1px solid #e9edf2;
    position: relative;
    overflow: hidden;
    transition: .25s;
    box-shadow:
        0 7px 22px
        rgba(0,0,0,.045);
}

.stat-card:hover {
    transform:
        translateY(-5px);
    box-shadow:
        0 15px 30px
        rgba(0,0,0,.08);
}

.stat-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.stat-title {
    color: #64748b;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: .8px;
}

.stat-icon {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 900;
}

.blue {
    border-top:
        3px solid #2563eb;
}

.blue .stat-icon {
    background: #eff6ff;
    color: #2563eb;
}

.orange {
    border-top:
        3px solid #ff9800;
}

.orange .stat-icon {
    background: #fff7ed;
    color: #ff9800;
}

.green {
    border-top:
        3px solid #16a34a;
}

.green .stat-icon {
    background: #f0fdf4;
    color: #16a34a;
}

.purple {
    border-top:
        3px solid #7c3aed;
}

.purple .stat-icon {
    background: #f5f3ff;
    color: #7c3aed;
}

.stat-value {
    color: #111827;
    font-size: 27px;
    font-weight: 900;
    margin-top: 18px;
    white-space: nowrap;
}

.stat-description {
    color: #94a3b8;
    font-size: 12px;
    margin-top: 5px;
}

.stat-decoration {
    position: absolute;
    width: 80px;
    height: 80px;
    right: -35px;
    bottom: -35px;
    border-radius: 50%;
    background:
        rgba(255,152,0,.05);
}

.dashboard-grid {
    display: grid;
    grid-template-columns:
        1.4fr .8fr;
    gap: 20px;
    margin-bottom: 25px;
}

.panel {
    background: white;
    border:
        1px solid #e9edf2;
    border-radius: 17px;
    padding: 25px;
    box-shadow:
        0 7px 22px
        rgba(0,0,0,.045);
}

.panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.panel-header h2 {
    color: #111827;
    font-size: 19px;
}

.view-link {
    color: #ff9800;
    font-size: 12px;
    font-weight: 800;
}

.booking-summary {
    display: grid;
    grid-template-columns:
        repeat(3,1fr);
    gap: 12px;
}

.booking-box {
    padding: 20px;
    border-radius: 12px;
    background: #f8fafc;
    border:
        1px solid #edf0f4;
}

.booking-box .number {
    font-size: 27px;
    font-weight: 900;
    color: #111827;
}

.booking-box p {
    color: #64748b;
    font-size: 12px;
    margin-top: 5px;
}

.booking-box.pending {
    border-left:
        4px solid #ff9800;
}

.booking-box.confirmed {
    border-left:
        4px solid #16a34a;
}

.booking-box.total {
    border-left:
        4px solid #7c3aed;
}

.revenue-panel {
    background:
        linear-gradient(
            135deg,
            #111827,
            #182338
        );
    color: white;
    border: none;
}

.revenue-panel .panel-header h2 {
    color: white;
}

.revenue-panel .view-link {
    color: #ff9800;
}

.revenue-label {
    color: #94a3b8;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.revenue-value {
    color: white;
    font-size: 34px;
    font-weight: 900;
    margin:
        12px 0 8px;
    white-space: nowrap;
}

.revenue-note {
    color: #94a3b8;
    font-size: 12px;
}

.revenue-line {
    height: 5px;
    background:
        rgba(255,255,255,.08);
    border-radius: 10px;
    margin-top: 25px;
    overflow: hidden;
}

.revenue-line span {
    display: block;
    width: 72%;
    height: 100%;
    background:
        linear-gradient(
            90deg,
            #ff9800,
            #ffb300
        );
    border-radius: 10px;
}

.quick-actions {
    display: grid;
    grid-template-columns:
        repeat(4,1fr);
    gap: 15px;
}

.action-card {
    padding: 22px;
    border-radius: 14px;
    background: #f8fafc;
    border:
        1px solid #e9edf2;
    transition: .25s;
}

.action-card:hover {
    background: white;
    border-color:
        #ff9800;
    transform:
        translateY(-4px);
    box-shadow:
        0 12px 25px
        rgba(0,0,0,.07);
}

.action-icon {
    width: 42px;
    height: 42px;
    border-radius: 10px;
    background: #fff3e0;
    color: #ff9800;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 900;
    margin-bottom: 15px;
}

.action-card h3 {
    color: #111827;
    font-size: 15px;
    margin-bottom: 6px;
}

.action-card p {
    color: #64748b;
    font-size: 12px;
    line-height: 1.5;
}

.footer-tagline {
    margin-top: 25px;
    text-align: center;
    padding: 18px;
    border-radius: 12px;
    background:
        linear-gradient(
            135deg,
            #ff9800,
            #ff7a00
        );
    color: white;
    font-size: 17px;
    font-weight: 800;
    box-shadow:
        0 8px 20px
        rgba(255,152,0,.18);
}

@media(max-width:1150px) {

    .stats {
        grid-template-columns:
            repeat(2,1fr);
    }

    .quick-actions {
        grid-template-columns:
            repeat(2,1fr);
    }
}

@media(max-width:900px) {

    .sidebar {
        width: 220px;
    }

    .main {
        margin-left: 220px;
        padding:
            25px 20px;
    }

    .dashboard-grid {
        grid-template-columns: 1fr;
    }
}

@media(max-width:650px) {

    .sidebar {
        position: relative;
        width: 100%;
        height: auto;
    }

    .main {
        margin-left: 0;
    }

    .stats {
        grid-template-columns: 1fr;
    }

    .quick-actions {
        grid-template-columns: 1fr;
    }

    .topbar {
        align-items:
            flex-start;
        gap: 15px;
        flex-direction:
            column;
    }

    .top-actions {
        width: 100%;
        justify-content:
            space-between;
    }

    .booking-summary {
        grid-template-columns:
            1fr;
    }

    .revenue-value {
        font-size: 28px;
    }
}

</style>

</head>

<body>

<aside class="sidebar">

    <div class="logo">

        <h1>
            RUTUL
            <span>MOTORS</span>
        </h1>

        <p>
            Commercial Vehicle Showroom
        </p>

    </div>

    <div class="menu-title">
        Main Menu
    </div>

    <ul class="menu">

        <li>
            <a href="dashboard.jsp"
               class="active">

                <span class="menu-icon">
                    D
                </span>

                Dashboard

            </a>
        </li>

        <li>
            <a href="vehicles.jsp">

                <span class="menu-icon">
                    V
                </span>

                Manage Vehicles

            </a>
        </li>

        <li>
            <a href="manageBookings.jsp">

                <span class="menu-icon">
                    B
                </span>

                Manage Bookings

            </a>
        </li>

        <li>
            <a href="sales.jsp">

                <span class="menu-icon">
                    S
                </span>

                Sales Management

            </a>
        </li>

    </ul>

    <div class="menu-title">
        Information
    </div>

    <ul class="menu">

        <li>
            <a href="about.jsp">

                <span class="menu-icon">
                    A
                </span>

                About Us

            </a>
        </li>

        <li>
            <a href="about.jsp#contact">

                <span class="menu-icon">
                    C
                </span>

                Contact

            </a>
        </li>

        <li>
            <a href="logout"
               class="logout">

                <span class="menu-icon">
                    X
                </span>

                Logout

            </a>
        </li>

    </ul>

</aside>

<main class="main">

    <div class="topbar">

        <div class="welcome">

            <small>
                Admin Control Center
            </small>

            <h1>
                Dashboard
            </h1>

            <p>
                Welcome back,

                <strong>
                    <%= fullName != null
                        ? fullName
                        : user %>
                </strong>
            </p>

        </div>

        <div class="top-actions">

            <div class="date-box">
                Rutul Motors
            </div>

            <a href="logout"
               class="logout-btn">
                Logout
            </a>

        </div>

    </div>

    <section class="hero-banner">

        <div class="hero-content">

            <div class="label">
                Rutul Motors
            </div>

            <h2>
                Built to Move
                <span>Business Forward.</span>
            </h2>

            <p>
                Manage your vehicles, bookings,
                sales and showroom operations
                from one powerful dashboard.
            </p>

            <div class="hero-tagline">
                Rutul Motors build to move forward
            </div>

        </div>

    </section>

    <section class="stats">

        <div class="stat-card blue">

            <div class="stat-top">

                <div class="stat-title">
                    AVAILABLE VEHICLES
                </div>

                <div class="stat-icon">
                    V
                </div>

            </div>

            <div class="stat-value">
                <%= vehicleCount %>
            </div>

            <div class="stat-description">
                Vehicles currently in stock
            </div>

            <div class="stat-decoration"></div>

        </div>

        <div class="stat-card orange">

            <div class="stat-top">

                <div class="stat-title">
                    TOTAL SALES
                </div>

                <div class="stat-icon">
                    S
                </div>

            </div>

            <div class="stat-value">
                <%= salesCount %>
            </div>

            <div class="stat-description">
                Completed vehicle sales
            </div>

            <div class="stat-decoration"></div>

        </div>

        <div class="stat-card green">

            <div class="stat-top">

                <div class="stat-title">
                    TOTAL REVENUE
                </div>

                <div class="stat-icon">
                    ₹
                </div>

            </div>

            <div class="stat-value">
                ₹<%= formattedRevenue %>
            </div>

            <div class="stat-description">
                Revenue generated
            </div>

            <div class="stat-decoration"></div>

        </div>

        <div class="stat-card purple">

            <div class="stat-top">

                <div class="stat-title">
                    TOTAL BOOKINGS
                </div>

                <div class="stat-icon">
                    B
                </div>

            </div>

            <div class="stat-value">
                <%= bookingCount %>
            </div>

            <div class="stat-description">
                Customer bookings
            </div>

            <div class="stat-decoration"></div>

        </div>

    </section>

    <section class="dashboard-grid">

        <div class="panel">

            <div class="panel-header">

                <h2>
                    Booking Overview
                </h2>

                <a href="manageBookings.jsp"
                   class="view-link">
                    View All
                </a>

            </div>

            <div class="booking-summary">

                <div class="booking-box total">

                    <div class="number">
                        <%= bookingCount %>
                    </div>

                    <p>
                        Total Bookings
                    </p>

                </div>

                <div class="booking-box pending">

                    <div class="number">
                        <%= pendingBookings %>
                    </div>

                    <p>
                        Pending
                    </p>

                </div>

                <div class="booking-box confirmed">

                    <div class="number">
                        <%= confirmedBookings %>
                    </div>

                    <p>
                        Confirmed
                    </p>

                </div>

            </div>

        </div>

        <div class="panel revenue-panel">

            <div class="panel-header">

                <h2>
                    Revenue
                </h2>

                <span class="view-link">
                    Sales
                </span>

            </div>

            <div class="revenue-label">
                Total Generated
            </div>

            <div class="revenue-value">
                ₹<%= formattedRevenue %>
            </div>

            <div class="revenue-note">
                Based on completed sales
            </div>

            <div class="revenue-line">
                <span></span>
            </div>

        </div>

    </section>

    <section class="panel">

        <div class="panel-header">

            <h2>
                Quick Actions
            </h2>

        </div>

        <div class="quick-actions">

            <a href="vehicles.jsp"
               class="action-card">

                <div class="action-icon">
                    V
                </div>

                <h3>
                    Manage Vehicles
                </h3>

                <p>
                    Add, edit, delete and
                    manage showroom vehicles.
                </p>

            </a>

            <a href="manageBookings.jsp"
               class="action-card">

                <div class="action-icon">
                    B
                </div>

                <h3>
                    Manage Bookings
                </h3>

                <p>
                    Review customer bookings
                    and update their status.
                </p>

            </a>

            <a href="sales.jsp"
               class="action-card">

                <div class="action-icon">
                    S
                </div>

                <h3>
                    Sales Management
                </h3>

                <p>
                    Record sales and track
                    revenue generated.
                </p>

            </a>

            <a href="about.jsp"
               class="action-card">

                <div class="action-icon">
                    A
                </div>

                <h3>
                    About Rutul Motors
                </h3>

                <p>
                    View showroom information,
                    services and contact details.
                </p>

            </a>

        </div>

    </section>

    <div class="footer-tagline">
        Rutul Motors — Build to Move Forward
    </div>

</main>

</body>

</html>