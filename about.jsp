<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        About Us | Rutul Motors
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


        html {

            scroll-behavior: smooth;
        }


        body {

            background: #f4f6f9;

            color: #111827;
        }


        /* =====================================================
           NAVBAR
        ===================================================== */

        .navbar {

            width: 100%;

            height: 75px;

            background: #111827;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 6%;

            position: sticky;

            top: 0;

            z-index: 1000;

            box-shadow:
                0 4px 15px
                rgba(0,0,0,0.15);
        }


        .logo {

            color: white;

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

            gap: 28px;
        }


        .nav-links a {

            color: #e5e7eb;

            text-decoration: none;

            font-size: 15px;

            font-weight: 500;

            transition: .3s;
        }


        .nav-links a:hover {

            color: #ff9800;
        }


        .nav-links .login-btn {

            background: #ff9800;

            color: #111827;

            padding: 10px 20px;

            border-radius: 8px;

            font-weight: 700;
        }


        .nav-links .login-btn:hover {

            background: #ffb300;

            color: #111827;
        }


        /* =====================================================
           HERO
        ===================================================== */

        .hero {

            min-height: 390px;

            display: flex;

            align-items: center;

            justify-content: center;

            text-align: center;

            padding: 70px 20px;

            background:
                linear-gradient(
                    rgba(17,24,39,.92),
                    rgba(17,24,39,.92)
                );
        }


        .hero-content {

            max-width: 850px;
        }


        .hero-small {

            color: #ff9800;

            font-size: 15px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 3px;

            margin-bottom: 15px;
        }


        .hero h1 {

            color: white;

            font-size: 52px;

            font-weight: 800;

            margin-bottom: 20px;
        }


        .hero h1 span {

            color: #ff9800;
        }


        .hero p {

            color: #d1d5db;

            font-size: 18px;

            line-height: 1.8;

            max-width: 700px;

            margin: auto;
        }


        /* =====================================================
           WHY SECTION
        ===================================================== */

        .why-section {

            width: 94%;

            max-width: 1400px;

            margin: -50px auto 60px;

            position: relative;

            background: white;

            padding: 45px 35px 55px;

            border-radius: 24px;

            box-shadow:
                0 20px 50px
                rgba(0,0,0,0.10);
        }


        .section-heading {

            text-align: center;

            margin-bottom: 40px;
        }


        .section-heading h2 {

            font-size: 36px;

            color: #111827;

            margin-bottom: 12px;
        }


        .section-heading h2 span {

            color: #ff9800;
        }


        .section-heading p {

            color: #64748b;

            font-size: 17px;
        }


        /* ORANGE LINE */

        .orange-line {

            width: 80px;

            height: 4px;

            background: #ff9800;

            margin: 18px auto;

            border-radius: 10px;
        }


        /* TAGLINE */

        .tagline {

            text-align: center;

            font-size: 21px;

            color: #374151;

            margin-bottom: 35px;

            font-weight: 500;
        }


        .tagline strong {

            color: #ff9800;

            font-weight: 800;
        }


        /* =====================================================
           FEATURE GRID
        ===================================================== */

        .why-grid {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 25px;
        }


        /* CARD */

        .why-card {

            position: relative;

            background:
                linear-gradient(
                    145deg,
                    #ffffff,
                    #f7f8fa
                );

            border: 1px solid #e5e7eb;

            border-radius: 20px;

            padding: 35px 25px 40px;

            text-align: center;

            min-height: 315px;

            overflow: hidden;

            transition:
                transform .3s,
                box-shadow .3s,
                border-color .3s;
        }


        .why-card:hover {

            transform:
                translateY(-8px);

            border-color:
                #ff9800;

            box-shadow:
                0 18px 35px
                rgba(0,0,0,0.10);
        }


        /* =====================================================
           ICON CIRCLE
        ===================================================== */

        .icon-circle {

            width: 82px;

            height: 82px;

            margin: 0 auto 22px;

            border-radius: 50%;

            background:
                linear-gradient(
                    135deg,
                    #ff9800,
                    #ffb300
                );

            display: flex;

            align-items: center;

            justify-content: center;

            color: white;

            font-size: 34px;

            font-weight: 800;

            border:
                7px solid #fff3e0;

            box-shadow:
                0 8px 20px
                rgba(255,152,0,.25);
        }


        /* CARD NUMBER */

        .card-number {

            position: absolute;

            right: 18px;

            bottom: 5px;

            font-size: 55px;

            font-weight: 800;

            color:
                rgba(17,24,39,.04);
        }


        .why-card h3 {

            font-size: 21px;

            color: #111827;

            margin-bottom: 15px;
        }


        .why-card h3::after {

            content: "";

            display: block;

            width: 35px;

            height: 3px;

            background: #ff9800;

            margin: 12px auto;
        }


        .why-card p {

            color: #64748b;

            font-size: 15px;

            line-height: 1.8;
        }


        /* =====================================================
           CONTACT SECTION
        ===================================================== */

        .contact-section {

            width: 94%;

            max-width: 1400px;

            margin: 0 auto 40px;

            min-height: 500px;

            border-radius: 24px;

            overflow: hidden;

            background:
                linear-gradient(
                    110deg,
                    #111827,
                    #182338
                );

            position: relative;

            box-shadow:
                0 20px 50px
                rgba(0,0,0,.15);
        }


        .contact-content {

            padding: 65px;

            max-width: 700px;

            position: relative;

            z-index: 2;
        }


        .contact-small {

            color: #ff9800;

            font-size: 16px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 2px;

            margin-bottom: 12px;
        }


        .contact-content h2 {

            color: white;

            font-size: 42px;

            margin-bottom: 18px;
        }


        .contact-content h2 span {

            color: #ff9800;
        }


        .contact-content > p {

            color: #cbd5e1;

            font-size: 17px;

            line-height: 1.7;

            margin-bottom: 30px;
        }


        /* =====================================================
           CONTACT DETAILS
        ===================================================== */

        .contact-item {

            display: flex;

            align-items: center;

            gap: 18px;

            padding: 15px 0;

            border-bottom:
                1px solid
                rgba(255,255,255,.12);

            max-width: 450px;
        }


        .contact-icon {

            width: 48px;

            height: 48px;

            flex-shrink: 0;

            border-radius: 50%;

            border:
                2px solid #ff9800;

            display: flex;

            align-items: center;

            justify-content: center;

            color: #ff9800;

            font-weight: 800;

            font-size: 20px;
        }


        .contact-item span {

            color: white;

            font-size: 17px;

            line-height: 1.5;
        }


        /* =====================================================
           WHATSAPP BUTTON
        ===================================================== */

        .whatsapp-btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 10px;

            margin-top: 30px;

            padding: 15px 28px;

            background: #25D366;

            color: white;

            text-decoration: none;

            border-radius: 35px;

            font-size: 16px;

            font-weight: 700;

            box-shadow:
                0 8px 20px
                rgba(37,211,102,.25);

            transition: .3s;
        }


        .whatsapp-btn:hover {

            background: #1ebe5d;

            transform:
                translateY(-3px);

            box-shadow:
                0 12px 25px
                rgba(37,211,102,.35);
        }


        /* =====================================================
           CONTACT SIDE DESIGN
        ===================================================== */

        .contact-decoration {

            position: absolute;

            right: -120px;

            top: 50%;

            transform:
                translateY(-50%);

            width: 550px;

            height: 550px;

            border-radius: 50%;

            background:
                radial-gradient(
                    circle,
                    rgba(255,152,0,.18),
                    transparent 65%
                );
        }


        .truck-box {

            position: absolute;

            right: 70px;

            top: 50%;

            transform:
                translateY(-50%);

            width: 330px;

            height: 220px;

            border-radius: 20px;

            background:
                linear-gradient(
                    135deg,
                    #ff9800,
                    #e67e00
                );

            opacity: .9;

            display: flex;

            align-items: center;

            justify-content: center;

            box-shadow:
                0 20px 40px
                rgba(0,0,0,.25);
        }


        .truck-box-text {

            color: white;

            font-size: 38px;

            font-weight: 900;

            text-align: center;

            line-height: 1.1;
        }


        .truck-box-text small {

            display: block;

            font-size: 16px;

            margin-top: 10px;

            letter-spacing: 3px;
        }


        /* =====================================================
           BOTTOM HIGHLIGHTS
        ===================================================== */

        .highlights {

            position: absolute;

            bottom: 0;

            left: 0;

            width: 100%;

            background:
                rgba(0,0,0,.20);

            padding: 18px 40px;

            display: flex;

            justify-content: center;

            gap: 80px;
        }


        .highlight-item {

            color: white;

            font-size: 15px;

            font-weight: 600;

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .highlight-item b {

            color: #ff9800;

            font-size: 22px;
        }


        /* =====================================================
           TAGLINE FOOTER
        ===================================================== */

        .bottom-tagline {

            width: 94%;

            max-width: 1400px;

            margin: 0 auto 35px;

            background:
                linear-gradient(
                    135deg,
                    #ff9800,
                    #ff7a00
                );

            color: white;

            padding: 22px;

            text-align: center;

            border-radius: 14px;

            font-size: 23px;

            font-weight: 800;

            letter-spacing: .3px;

            box-shadow:
                0 10px 25px
                rgba(255,152,0,.25);
        }


        .bottom-tagline span {

            margin-left: 8px;
        }


        /* =====================================================
           FOOTER
        ===================================================== */

        footer {

            background: #111827;

            color: #9ca3af;

            text-align: center;

            padding: 25px;

            font-size: 14px;
        }


        footer strong {

            color: #ff9800;
        }


        /* =====================================================
           RESPONSIVE
        ===================================================== */

        @media(max-width:1100px) {

            .why-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .truck-box {

                opacity: .2;

                right: 20px;
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

                gap: 15px;

                flex-wrap: wrap;

                justify-content:
                    center;
            }


            .hero h1 {

                font-size: 38px;
            }


            .why-section {

                width: 94%;

                padding:
                    35px 20px;
            }


            .why-grid {

                grid-template-columns:
                    1fr;
            }


            .contact-content {

                padding:
                    45px 30px 120px;
            }


            .contact-content h2 {

                font-size: 34px;
            }


            .truck-box {

                display: none;
            }


            .highlights {

                gap: 20px;

                padding:
                    15px;

                flex-wrap: wrap;
            }


            .highlight-item {

                font-size: 13px;
            }


            .bottom-tagline {

                font-size: 18px;
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


        <a href="index.jsp">
            Home
        </a>


        <a href="dashboard.jsp">
            Dashboard
        </a>


        <a href="vehicles.jsp">
            Vehicles
        </a>


        <a href="about.jsp">
            About Us
        </a>


        <a href="login.html"
           class="login-btn">

            Login

        </a>


    </div>


</nav>



<!-- =====================================================
     HERO
===================================================== -->


<section class="hero">


    <div class="hero-content">


        <div class="hero-small">

            Commercial Vehicle Showroom

        </div>


        <h1>

            About <span>Rutul Motors</span>

        </h1>


        <p>

            Your trusted destination for reliable
            commercial and heavy vehicles.
            We help businesses find the right
            vehicle to keep their operations moving.

        </p>


    </div>


</section>



<!-- =====================================================
     WHY CHOOSE US
===================================================== -->


<section class="why-section">


    <div class="section-heading">


        <h2>

            Why Choose
            <span>Rutul Motors?</span>

        </h2>


        <div class="orange-line"></div>


        <p>

            Quality vehicles. Trusted service.
            Customer-first approach.

        </p>


    </div>


    <!-- TAGLINE -->

    <div class="tagline">

        Rutul Motors
        <strong>
            build to move forward
        </strong>

    </div>


    <div class="why-grid">


        <!-- =================================================
             QUALITY
        ================================================= -->


        <div class="why-card">


            <div class="icon-circle">

                ✓

            </div>


            <h3>

                Quality Vehicles

            </h3>


            <p>

                Reliable commercial and heavy
                vehicles for different business
                requirements.

            </p>


            <div class="card-number">

                01

            </div>


        </div>



        <!-- =================================================
             CUSTOMER FIRST
        ================================================= -->


        <div class="why-card">


            <div class="icon-circle">

                ★

            </div>


            <h3>

                Customer First

            </h3>


            <p>

                We focus on understanding our
                customers' requirements and
                helping them choose the right
                vehicle.

            </p>


            <div class="card-number">

                02

            </div>


        </div>



        <!-- =================================================
             TRUSTED SERVICE
        ================================================= -->


        <div class="why-card">


            <div class="icon-circle">

                ✓

            </div>


            <h3>

                Trusted Service

            </h3>


            <p>

                Professional and transparent
                service from enquiry to
                delivery.

            </p>


            <div class="card-number">

                03

            </div>


        </div>



        <!-- =================================================
             LOCAL PRESENCE
        ================================================= -->


        <div class="why-card">


            <div class="icon-circle">

                ●

            </div>


            <h3>

                Local Presence

            </h3>


            <p>

                Conveniently located at
                Alephata, Junnar, Pune,
                Maharashtra.

            </p>


            <div class="card-number">

                04

            </div>


        </div>


    </div>


</section>



<!-- =====================================================
     CONTACT SECTION
===================================================== -->


<section class="contact-section"
         id="contact">


    <!-- DECORATION -->

    <div class="contact-decoration"></div>


    <div class="truck-box">


        <div class="truck-box-text">

            RUTUL

            <small>
                MOTORS
            </small>

        </div>


    </div>


    <!-- CONTACT CONTENT -->

    <div class="contact-content">


        <div class="contact-small">

            Get In Touch

        </div>


        <h2>

            We're Here
            <span>to Help You</span>

        </h2>


        <p>

            Have questions or ready to get started?

            Reach out to Rutul Motors today
            and let us help you find the right
            commercial vehicle for your business.

        </p>


        <!-- LOCATION -->

        <div class="contact-item">


            <div class="contact-icon">

                L

            </div>


            <span>

                Alephata, Junnar,
                Pune, Maharashtra

            </span>


        </div>


        <!-- PHONE 1 -->

        <div class="contact-item">


            <div class="contact-icon">

                P

            </div>


            <span>

                9890145690

            </span>


        </div>


        <!-- PHONE 2 -->

        <div class="contact-item">


            <div class="contact-icon">

                P

            </div>


            <span>

                7448252555

            </span>


        </div>


        <!-- WHATSAPP -->

        <a
            href="https://wa.me/919890145690"
            target="_blank"
            class="whatsapp-btn">

            WhatsApp Rutul Motors

        </a>


    </div>


    <!-- BOTTOM HIGHLIGHTS -->

    <div class="highlights">


        <div class="highlight-item">

            <b>✓</b>

            Best Quality

        </div>


        <div class="highlight-item">

            <b>✓</b>

            Reliable Support

        </div>


        <div class="highlight-item">

            <b>✓</b>

            Built to Move Forward

        </div>


    </div>


</section>



<!-- =====================================================
     BIG TAGLINE
===================================================== -->


<div class="bottom-tagline">

    Rutul Motors

    <span>
        build to move forward
    </span>

</div>



<!-- =====================================================
     FOOTER
===================================================== -->


<footer>

    © 2026

    <strong>
        Rutul Motors
    </strong>

    — Commercial Vehicle Showroom

</footer>


</body>

</html>