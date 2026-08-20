package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Dao.DBConnection;

@WebServlet("/BookingStatusServlet")
public class BookingStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check login
        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("login.html");
            return;
        }

        // Check admin role
        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "customerDashboard.jsp"
            );

            return;
        }


        String bookingIdParam =
                request.getParameter("booking_id");

        String status =
                request.getParameter("status");


        if (bookingIdParam == null ||
            status == null) {

            response.sendRedirect(
                    "manageBookings.jsp"
            );

            return;
        }


        int bookingId;

        try {

            bookingId =
                    Integer.parseInt(bookingIdParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "manageBookings.jsp"
            );

            return;
        }


        // Only allow these two statuses
        if (!"Confirmed".equalsIgnoreCase(status) &&
            !"Cancelled".equalsIgnoreCase(status)) {

            response.sendRedirect(
                    "manageBookings.jsp"
            );

            return;
        }


        Connection con = null;
        PreparedStatement ps = null;


        try {

            con =
                    DBConnection.getConnection();


            String sql =
                    "UPDATE bookings " +
                    "SET status = ? " +
                    "WHERE booking_id = ? " +
                    "AND status = 'Pending'";


            ps =
                    con.prepareStatement(sql);


            ps.setString(1, status);

            ps.setInt(2, bookingId);


            ps.executeUpdate();


            response.sendRedirect(
                    "manageBookings.jsp"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                    "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                    "<h2>Booking Status Error</h2>"
            );

            response.getWriter().println(
                    "<p>" +
                    e.getMessage() +
                    "</p>"
            );


        } finally {

            try {

                if (ps != null) {
                    ps.close();
                }

            } catch (Exception ignored) {
            }


            try {

                if (con != null) {
                    con.close();
                }

            } catch (Exception ignored) {
            }

        }
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                "manageBookings.jsp"
        );
    }
}