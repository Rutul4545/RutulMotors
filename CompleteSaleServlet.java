package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Dao.DBConnection;

@WebServlet("/CompleteSaleServlet")
public class CompleteSaleServlet extends HttpServlet {

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

        // Only ADMIN can complete a sale
        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "customerDashboard.jsp"
            );

            return;
        }

        String bookingParam =
                request.getParameter("booking_id");

        if (bookingParam == null ||
            bookingParam.trim().isEmpty()) {

            response.sendRedirect(
                    "manageBookings.jsp?error=Invalid+booking"
            );

            return;
        }

        int bookingId;

        try {

            bookingId =
                    Integer.parseInt(bookingParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "manageBookings.jsp?error=Invalid+booking"
            );

            return;
        }

        Connection con = null;
        PreparedStatement bookingPs = null;
        PreparedStatement checkSalePs = null;
        PreparedStatement salePs = null;

        ResultSet bookingRs = null;
        ResultSet saleRs = null;

        try {

            con =
                    DBConnection.getConnection();

            /*
             * Start transaction
             */
            con.setAutoCommit(false);

            /*
             * Get booking + vehicle price
             */
            String bookingSql =
                    "SELECT b.vehicle_id, " +
                    "b.customer_id, " +
                    "b.status, " +
                    "v.price " +
                    "FROM bookings b " +
                    "INNER JOIN vehicles v " +
                    "ON b.vehicle_id = v.vehicle_id " +
                    "WHERE b.booking_id = ? " +
                    "FOR UPDATE";

            bookingPs =
                    con.prepareStatement(bookingSql);

            bookingPs.setInt(
                    1,
                    bookingId
            );

            bookingRs =
                    bookingPs.executeQuery();

            /*
             * Booking not found
             */
            if (!bookingRs.next()) {

                con.rollback();

                response.sendRedirect(
                        "manageBookings.jsp?error=Booking+not+found"
                );

                return;
            }

            int vehicleId =
                    bookingRs.getInt("vehicle_id");

            int customerId =
                    bookingRs.getInt("customer_id");

            String status =
                    bookingRs.getString("status");

            double amount =
                    bookingRs.getDouble("price");

            /*
             * Only CONFIRMED bookings
             * can become sales.
             */
            if (!"Confirmed".equalsIgnoreCase(status)) {

                con.rollback();

                response.sendRedirect(
                        "manageBookings.jsp?error=Only+confirmed+bookings+can+be+completed"
                );

                return;
            }

            /*
             * Check whether this booking
             * already has a sale.
             */
            String checkSaleSql =
                    "SELECT sale_id " +
                    "FROM sales " +
                    "WHERE booking_id = ?";

            checkSalePs =
                    con.prepareStatement(checkSaleSql);

            checkSalePs.setInt(
                    1,
                    bookingId
            );

            saleRs =
                    checkSalePs.executeQuery();

            if (saleRs.next()) {

                con.rollback();

                response.sendRedirect(
                        "manageBookings.jsp?error=Sale+already+exists"
                );

                return;
            }

            /*
             * Create sale.
             */
            String saleSql =
                    "INSERT INTO sales " +
                    "(booking_id, vehicle_id, customer_id, " +
                    "sale_date, amount) " +
                    "VALUES (?, ?, ?, CURDATE(), ?)";

            salePs =
                    con.prepareStatement(saleSql);

            salePs.setInt(
                    1,
                    bookingId
            );

            salePs.setInt(
                    2,
                    vehicleId
            );

            salePs.setInt(
                    3,
                    customerId
            );

            salePs.setDouble(
                    4,
                    amount
            );

            salePs.executeUpdate();

            /*
             * Do NOT decrease vehicle stock here.
             *
             * Stock was already decreased
             * when the booking was created.
             */

            con.commit();

            response.sendRedirect(
                    "manageBookings.jsp?success=sale"
            );

        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception ignored) {
            }

            response.setContentType(
                    "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                    "<h2>Sale Error</h2>"
            );

            response.getWriter().println(
                    "<p>" +
                    e.getMessage() +
                    "</p>"
            );

            response.getWriter().println(
                    "<br>"
            );

            response.getWriter().println(
                    "<a href='manageBookings.jsp'>" +
                    "Back to Manage Bookings" +
                    "</a>"
            );

        } finally {

            try {
                if (saleRs != null) {
                    saleRs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (bookingRs != null) {
                    bookingRs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (checkSalePs != null) {
                    checkSalePs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (bookingPs != null) {
                    bookingPs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (salePs != null) {
                    salePs.close();
                }
            } catch (Exception ignored) {
            }

            try {

                if (con != null) {

                    con.setAutoCommit(true);

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