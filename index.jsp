<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="Dao.DBConnection" %>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Rutul Motors | Commercial Vehicles</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Segoe UI", Arial, sans-serif;
}

html {
    scroll-behavior: smooth;
}

body {
    background: #f5f7fa;
    color: #111827;
}

a {
    text-decoration: none;
}

.navbar {
    height: 76px;
    background: rgba(10,16,28,.97);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 6%;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
    border-bottom: 1px solid rgba(255,255,255,.06);
}

.logo {
    color: white;
    font-size: 26px;
    font-weight: 900;
    letter-spacing: 1px;
}

.logo span {
    color: #ff9800;
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 27px;
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

.login-btn {
    background: linear-gradient(135deg,#ff9800,#ff7a00);
    color: white !important;
    padding: 11px 20px;
    border-radius: 9px;
    font-weight: 800 !important;
}

.register-btn {
    border: 1px solid rgba(255,152,0,.65);
    color: #ff9800 !important;
    padding: 10px 18px;
    border-radius: 9px;
}

.hero {
    min-height: 760px;
    display: flex;
    align-items: center;
    position: relative;
    background:
        linear-gradient(
            90deg,
            rgba(5,10,20,.94) 0%,
            rgba(5,10,20,.78) 43%,
            rgba(5,10,20,.38) 75%,
            rgba(5,10,20,.58) 100%
        ),
        url("images/trucks.jpeg");
    background-size: cover;
    background-position: center;
    padding-top: 76px;
    overflow: hidden;
}

.hero::after {
    content: "";
    position: absolute;
    width: 500px;
    height: 500px;
    right: -180px;
    bottom: -250px;
    border-radius: 50%;
    background: rgba(255,152,0,.17);
    filter: blur(80px);
}

.hero-content {
    position: relative;
    z-index: 2;
    width: 92%;
    max-width: 1400px;
    margin: auto;
    padding: 60px 0;
}

.hero-label {
    display: inline-block;
    color: #ff9800;
    font-size: 13px;
    font-weight: 800;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 17px;
}

.hero h1 {
    color: white;
    font-size: 65px;
    line-height: 1.05;
    font-weight: 900;
    max-width: 760px;
}

.hero h1 span {
    color: #ff9800;
}

.hero-description {
    color: #d7dde7;
    font-size: 18px;
    line-height: 1.8;
    max-width: 660px;
    margin-top: 24px;
}

.hero-buttons {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-top: 32px;
}

.primary-btn {
    background: linear-gradient(135deg,#ff9800,#ff7a00);
    color: white;
    padding: 15px 27px;
    border-radius: 10px;
    font-size: 15px;
    font-weight: 800;
    box-shadow: 0 10px 25px rgba(255,152,0,.23);
    transition: .3s;
}

.primary-btn:hover {
    transform: translateY(-3px);
}

.secondary-btn {
    color: white;
    border: 1px solid rgba(255,255,255,.35);
    padding: 14px 26px;
    border-radius: 10px;
    font-size: 15px;
    font-weight: 700;
    transition: .3s;
}

.secondary-btn:hover {
    background: white;
    color: #111827;
}

.hero-tagline {
    display: inline-block;
    margin-top: 28px;
    padding: 10px 17px;
    border-left: 4px solid #ff9800;
    background: rgba(255,255,255,.07);
    color: #f3f4f6;
    font-size: 14px;
    font-weight: 700;
}

.hero-stats {
    display: flex;
    gap: 45px;
    margin-top: 45px;
}

.hero-stat {
    border-left: 2px solid #ff9800;
    padding-left: 15px;
}

.hero-stat strong {
    display: block;
    color: white;
    font-size: 25px;
    font-weight: 900;
}

.hero-stat span {
    color: #9ca3af;
    font-size: 12px;
}

.section {
    width: 92%;
    max-width: 1400px;
    margin: auto;
    padding: 85px 0;
}

.section-heading {
    text-align: center;
    margin-bottom: 45px;
}

.section-heading .small {
    color: #ff9800;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 2px;
    text-transform: uppercase;
}

.section-heading h2 {
    color: #111827;
    font-size: 38px;
    margin-top: 8px;
}

.section-heading h2 span {
    color: #ff9800;
}

.section-heading p {
    color: #64748b;
    font-size: 16px;
    max-width: 650px;
    margin: 12px auto 0;
    line-height: 1.7;
}

.orange-line {
    width: 75px;
    height: 4px;
    background: #ff9800;
    margin: 17px auto;
    border-radius: 10px;
}

.service-grid {
    display: grid;
    grid-template-columns: repeat(3,1fr);
    gap: 22px;
}

.service-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 18px;
    padding: 32px;
    transition: .3s;
    box-shadow: 0 7px 25px rgba(0,0,0,.045);
}

.service-card:hover {
    transform: translateY(-7px);
    border-color: #ff9800;
}

.service-number {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    background: #fff3e0;
    color: #ff9800;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    font-weight: 900;
    margin-bottom: 22px;
}

.service-card h3 {
    color: #111827;
    font-size: 20px;
    margin-bottom: 10px;
}

.service-card p {
    color: #64748b;
    font-size: 14px;
    line-height: 1.7;
}

.vehicles-section {
    background: white;
}

.vehicle-grid {
    display: grid;
    grid-template-columns: repeat(3,1fr);
    gap: 25px;
}

.vehicle-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 18px;
    overflow: hidden;
    box-shadow: 0 8px 25px rgba(0,0,0,.05);
    transition: .3s;
}

.vehicle-card:hover {
    transform: translateY(-7px);
    border-color: #ff9800;
}

.vehicle-image {
    height: 210px;
    background:
        linear-gradient(
            rgba(17,24,39,.2),
            rgba(17,24,39,.35)
        ),
        url("images/trucks.jpeg");
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
    padding: 7px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 800;
}

.vehicle-content {
    padding: 22px;
}

.vehicle-brand {
    color: #ff9800;
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: 800;
}

.vehicle-name {
    color: #111827;
    font-size: 21px;
    font-weight: 900;
    margin: 7px 0;
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
    border-top: 1px solid #edf0f4;
    padding-top: 16px;
}

.vehicle-price {
    color: #111827;
    font-size: 19px;
    font-weight: 900;
}

.vehicle-price small {
    display: block;
    color: #94a3b8;
    font-size: 9px;
    font-weight: 500;
}

.view-btn {
    background: #111827;
    color: white;
    padding: 9px 15px;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 800;
    transition: .25s;
}

.view-btn:hover {
    background: #ff9800;
    color: #111827;
}

.about-strip {
    background: linear-gradient(110deg,#111827,#1b2940);
    color: white;
}

.about-content {
    display: grid;
    grid-template-columns: 1.2fr .8fr;
    align-items: center;
    gap: 60px;
}

.about-text .small {
    color: #ff9800;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 2px;
}

.about-text h2 {
    font-size: 38px;
    margin: 10px 0 18px;
}

.about-text h2 span {
    color: #ff9800;
}

.about-text p {
    color: #cbd5e1;
    line-height: 1.8;
    font-size: 15px;
}

.about-btn {
    display: inline-block;
    margin-top: 25px;
    color: #111827;
    background: #ff9800;
    padding: 12px 22px;
    border-radius: 9px;
    font-size: 13px;
    font-weight: 800;
}

.about-boxes {
    display: grid;
    grid-template-columns: repeat(2,1fr);
    gap: 15px;
}

.about-box {
    padding: 25px;
    background: rgba(255,255,255,.06);
    border: 1px solid rgba(255,255,255,.08);
    border-radius: 15px;
}

.about-box strong {
    display: block;
    color: #ff9800;
    font-size: 27px;
    margin-bottom: 5px;
}

.about-box span {
    color: #cbd5e1;
    font-size: 12px;
}

.why-grid {
    display: grid;
    grid-template-columns: repeat(4,1fr);
    gap: 20px;
}

.why-card {
    text-align: center;
    background: white;
    padding: 30px 20px;
    border-radius: 17px;
    border: 1px solid #e5e7eb;
    transition: .3s;
}

.why-card:hover {
    transform: translateY(-5px);
    border-color: #ff9800;
}

.why-icon {
    width: 68px;
    height: 68px;
    margin: 0 auto 18px;
    border-radius: 50%;
    background: #fff3e0;
    color: #ff9800;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 27px;
    font-weight: 900;
}

.why-card h3 {
    color: #111827;
    font-size: 17px;
    margin-bottom: 10px;
}

.why-card p {
    color: #64748b;
    font-size: 13px;
    line-height: 1.7;
}

.cta {
    width: 92%;
    max-width: 1400px;
    margin: 30px auto 70px;
    padding: 60px 40px;
    border-radius: 22px;
    text-align: center;
    background: linear-gradient(135deg,#ff9800,#ff7300);
    color: white;
}

.cta h2 {
    font-size: 35px;
    margin-bottom: 12px;
}

.cta p {
    font-size: 15px;
    margin-bottom: 25px;
}

.cta-btn {
    display: inline-block;
    background: #111827;
    color: white;
    padding: 13px 25px;
    border-radius: 9px;
    font-size: 14px;
    font-weight: 800;
}

footer {
    background: #0b1220;
    color: #94a3b8;
    padding: 45px 6% 25px;
}

.footer-grid {
    max-width: 1400px;
    margin: auto;
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr;
    gap: 50px;
    padding-bottom: 30px;
    border-bottom: 1px solid rgba(255,255,255,.08);
}

.footer-brand h2 {
    color: white;
    font-size: 24px;
}

.footer-brand h2 span {
    color: #ff9800;
}

.footer-brand p {
    margin-top: 12px;
    font-size: 13px;
    line-height: 1.7;
    max-width: 400px;
}

footer h3 {
    color: white;
    font-size: 15px;
    margin-bottom: 15px;
}

footer a {
    display: block;
    color: #94a3b8;
    font-size: 13px;
    margin-bottom: 10px;
}

footer a:hover {
    color: #ff9800;
}

.copyright {
    max-width: 1400px;
    margin: 22px auto 0;
    text-align: center;
    font-size: 12px;
}

.copyright strong {
    color: #ff9800;
}

@media(max-width:1000px) {

    .hero h1 {
        font-size: 50px;
    }

    .why-grid {
        grid-template-columns: repeat(2,1fr);
    }

    .vehicle-grid {
        grid-template-columns: repeat(2,1fr);
    }

    .about-content {
        grid-template-columns: 1fr;
    }
}

@media(max-width:750px) {

    .navbar {
        height: auto;
        padding: 17px 25px;
        flex-direction: column;
        gap: 15px;
    }

    .nav-links {
        flex-wrap: wrap;
        justify-content: center;
        gap: 13px;
    }

    .hero {
        min-height: 650px;
        padding-top: 120px;
    }

    .hero h1 {
        font-size: 39px;
    }

    .hero-description {
        font-size: 15px;
    }

    .hero-buttons {
        flex-direction: column;
        align-items: flex-start;
    }

    .hero-stats {
        gap: 20px;
        flex-wrap: wrap;
    }

    .service-grid,
    .vehicle-grid,
    .why-grid {
        grid-template-columns: 1fr;
    }

    .section-heading h2,
    .about-text h2 {
        font-size: 30px;
    }

    .footer-grid {
        grid-template-columns: 1fr;
    }
}

@media(max-width:500px) {

    .hero-content {
        width: 94%;
    }

    .hero h1 {
        font-size: 34px;
    }

    .hero-stat strong {
        font-size: 21px;
    }

    .about-boxes {
        grid-template-columns: 1fr;
    }
}

</style>

<link rel="stylesheet" href="polish.css">

</head>

<body>

<nav class="navbar">

    <div class="logo">
        RUTUL <span>MOTORS</span>
    </div>

    <div class="nav-links">

        <a href="index.jsp">
            Home
        </a>

        <a href="about.jsp">
            About
        </a>

        <a href="customerVehicles.jsp">
            Vehicles
        </a>

        <a href="login.html"
           class="login-btn">
            Login
        </a>

        <a href="register.html"
           class="register-btn">
            Register
        </a>

    </div>

</nav>

<section class="hero">

    <div class="hero-content">

        <div class="hero-label">
            Commercial Vehicle Showroom
        </div>

        <h1>
            Built for Business.
            <br>
            <span>Built to Move.</span>
        </h1>

        <p class="hero-description">

            Discover reliable commercial and
            heavy vehicles designed to keep your
            business moving forward.

            At Rutul Motors, we connect you with
            the right vehicle for the road ahead.

        </p>

        <div class="hero-buttons">

            <a href="customerVehicles.jsp"
               class="primary-btn">
                Explore Vehicles
            </a>

            <a href="about.jsp"
               class="secondary-btn">
                Discover Rutul Motors
            </a>

        </div>

        <div class="hero-tagline">
            Rutul Motors — Build to Move Forward
        </div>

        <div class="hero-stats">

            <div class="hero-stat">
                <strong>40+</strong>
                <span>Vehicles Available</span>
            </div>

            <div class="hero-stat">
                <strong>24/7</strong>
                <span>Customer Enquiries</span>
            </div>

            <div class="hero-stat">
                <strong>100%</strong>
                <span>Customer Focus</span>
            </div>

        </div>

    </div>

</section>

<section class="section">

    <div class="section-heading">

        <div class="small">
            What We Offer
        </div>

        <h2>
            Everything You Need
            <span>Under One Roof</span>
        </h2>

        <div class="orange-line"></div>

        <p>
            From finding the right vehicle to
            booking and customer support,
            Rutul Motors makes the process simple.
        </p>

    </div>

    <div class="service-grid">

        <div class="service-card">

            <div class="service-number">
                01
            </div>

            <h3>
                Commercial Vehicles
            </h3>

            <p>
                Explore a range of reliable
                commercial and heavy vehicles
                suitable for different business
                requirements.
            </p>

        </div>

        <div class="service-card">

            <div class="service-number">
                02
            </div>

            <h3>
                Easy Booking
            </h3>

            <p>
                Browse available vehicles and
                submit your booking request
                through our simple online system.
            </p>

        </div>

        <div class="service-card">

            <div class="service-number">
                03
            </div>

            <h3>
                Trusted Support
            </h3>

            <p>
                Our customer-first approach
                helps you choose the vehicle
                that fits your business.
            </p>

        </div>

    </div>

</section>

<section class="section vehicles-section">

    <div class="section-heading">

        <div class="small">
            Our Collection
        </div>

        <h2>
            Featured
            <span>Vehicles</span>
        </h2>

        <div class="orange-line"></div>

        <p>
            Take a look at some of the vehicles
            available at Rutul Motors.
        </p>

    </div>

    <div class="vehicle-grid">

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int count = 0;

    try {

        con = DBConnection.getConnection();

        ps = con.prepareStatement(
            "SELECT vehicle_id, vehicle_name, vehicle_type, brand, price " +
            "FROM vehicles " +
            "ORDER BY vehicle_id DESC"
        );

        rs = ps.executeQuery();

        while (rs.next() && count < 3) {

            String vehicleName =
                rs.getString("vehicle_name");

            String vehicleType =
                rs.getString("vehicle_type");

            String brand =
                rs.getString("brand");

            double price =
                rs.getDouble("price");

            DecimalFormat indianFormat =
                new DecimalFormat("#,##,##0");

            String formattedPrice =
                indianFormat.format(price);
%>

        <div class="vehicle-card">

            <div class="vehicle-image">

                <div class="vehicle-badge">
                    <%= brand != null ? brand : "Vehicle" %>
                </div>

            </div>

            <div class="vehicle-content">

                <div class="vehicle-brand">
                    <%= brand != null ? brand : "Rutul Motors" %>
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
                            Vehicle Price
                        </small>

                    </div>

                    <a href="customerVehicles.jsp"
                       class="view-btn">
                        View Vehicle
                    </a>

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
            if (rs != null) rs.close();
        } catch (Exception ignored) {}

        try {
            if (ps != null) ps.close();
        } catch (Exception ignored) {}

        try {
            if (con != null) con.close();
        } catch (Exception ignored) {}
    }
%>

    </div>

</section>

<section class="about-strip">

    <div class="section about-content">

        <div class="about-text">

            <div class="small">
                About Rutul Motors
            </div>

            <h2>
                Your Journey Starts
                <span>Here.</span>
            </h2>

            <p>

                Rutul Motors is a commercial vehicle
                showroom focused on providing
                reliable vehicles and a simple,
                transparent customer experience.

                Whether you need a heavy vehicle
                for transportation, logistics or
                business operations, we help you
                move towards the right choice.

            </p>

            <a href="about.jsp"
               class="about-btn">
                Learn More About Us
            </a>

        </div>

        <div class="about-boxes">

            <div class="about-box">
                <strong>40+</strong>
                <span>Vehicles in Collection</span>
            </div>

            <div class="about-box">
                <strong>100%</strong>
                <span>Customer Focus</span>
            </div>

            <div class="about-box">
                <strong>1</strong>
                <span>Trusted Showroom</span>
            </div>

            <div class="about-box">
                <strong>Pune</strong>
                <span>Maharashtra</span>
            </div>

        </div>

    </div>

</section>

<section class="section">

    <div class="section-heading">

        <div class="small">
            Why Rutul Motors
        </div>

        <h2>
            Why Choose
            <span>Us?</span>
        </h2>

        <div class="orange-line"></div>

    </div>

    <div class="why-grid">

        <div class="why-card">

            <div class="why-icon">
                Q
            </div>

            <h3>
                Quality Vehicles
            </h3>

            <p>
                Reliable commercial vehicles
                selected for business needs.
            </p>

        </div>

        <div class="why-card">

            <div class="why-icon">
                C
            </div>

            <h3>
                Customer First
            </h3>

            <p>
                We focus on understanding
                every customer's requirements.
            </p>

        </div>

        <div class="why-card">

            <div class="why-icon">
                T
            </div>

            <h3>
                Trusted Service
            </h3>

            <p>
                Transparent service from
                enquiry to vehicle delivery.
            </p>

        </div>

        <div class="why-card">

            <div class="why-icon">
                R
            </div>

            <h3>
                Reliable Support
            </h3>

            <p>
                Support when you need it,
                from a team that cares.
            </p>

        </div>

    </div>

</section>

<section class="cta">

    <h2>
        Ready to Move Forward?
    </h2>

    <p>
        Explore our commercial vehicles
        and find the right one for your business.
    </p>

    <a href="customerVehicles.jsp"
       class="cta-btn">
        Browse Vehicles
    </a>

</section>

<footer>

    <div class="footer-grid">

        <div class="footer-brand">

            <h2>
                RUTUL <span>MOTORS</span>
            </h2>

            <p>
                Commercial vehicle showroom
                providing reliable vehicles
                for businesses that keep moving.
            </p>

        </div>

        <div>

            <h3>
                Quick Links
            </h3>

            <a href="index.jsp">
                Home
            </a>

            <a href="about.jsp">
                About Us
            </a>

            <a href="customerVehicles.jsp">
                Vehicles
            </a>

            <a href="login.html">
                Login
            </a>

        </div>

        <div>

            <h3>
                Contact
            </h3>

            <a href="about.jsp#contact">
                Alephata, Junnar,
                Pune, Maharashtra
            </a>

            <a href="tel:9890145690">
                9890145690
            </a>

            <a href="tel:7448252555">
                7448252555
            </a>

        </div>

    </div>

    <div class="copyright">

        Rutul Motors —
        <strong>
            Build to Move Forward
        </strong>

        <br>

        © 2026 Rutul Motors.
        All Rights Reserved.

    </div>

</footer>

</body>
</html>