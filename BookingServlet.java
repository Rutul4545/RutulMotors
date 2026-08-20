package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("login.html");
            return;
        }

        // Get customer ID from session
        int customerId =
                (Integer) session.getAttribute("userId");

        // Get vehicle ID from form
        String vehicleIdParam =
                request.getParameter("vehicle_id");

        if (vehicleIdParam == null ||
            vehicleIdParam.trim().isEmpty()) {

            response.sendRedirect(
                    "bookVehicle.jsp?error=vehicle"
            );

            return;
        }

        int vehicleId;

        try {

            vehicleId =
                    Integer.parseInt(vehicleIdParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "bookVehicle.jsp?error=vehicle"
            );

            return;
        }


        Connection con = null;
        PreparedStatement stockPs = null;
        PreparedStatement insertPs = null;
        PreparedStatement updatePs = null;
        ResultSet rs = null;

        try {

            /*
             * Use your existing DBConnection class
             */
            con = Dao.DBConnection.getConnection();

            /*
             * Start transaction
             */
            con.setAutoCommit(false);


            /*
             * STEP 1
             * Check vehicle stock.
             *
             * FOR UPDATE prevents two customers
             * from booking the last vehicle
             * at the same time.
             */
            String stockSql =
                    "SELECT stock " +
                    "FROM vehicles " +
                    "WHERE vehicle_id = ? " +
                    "FOR UPDATE";

            stockPs =
                    con.prepareStatement(stockSql);

            stockPs.setInt(1, vehicleId);

            rs = stockPs.executeQuery();


            /*
             * Vehicle doesn't exist
             */
            if (!rs.next()) {

                con.rollback();

                response.sendRedirect(
                        "bookVehicle.jsp?error=notfound"
                );

                return;
            }


            int stock =
                    rs.getInt("stock");


            /*
             * No stock
             */
            if (stock <= 0) {

                con.rollback();

                response.sendRedirect(
                        "bookVehicle.jsp?error=outofstock"
                );

                return;
            }


            /*
             * STEP 2
             * Create booking
             */
            String insertSql =
                    "INSERT INTO bookings " +
                    "(vehicle_id, customer_id, booking_date, status) " +
                    "VALUES (?, ?, ?, ?)";

            insertPs =
                    con.prepareStatement(insertSql);

            insertPs.setInt(1, vehicleId);

            insertPs.setInt(2, customerId);

            insertPs.setDate(
                    3,
                    new Date(
                        System.currentTimeMillis()
                    )
            );

            insertPs.setString(
                    4,
                    "Pending"
            );

            insertPs.executeUpdate();


            /*
             * STEP 3
             * Reduce vehicle stock by 1
             */
            String updateSql =
                    "UPDATE vehicles " +
                    "SET stock = stock - 1 " +
                    "WHERE vehicle_id = ? " +
                    "AND stock > 0";

            updatePs =
                    con.prepareStatement(updateSql);

            updatePs.setInt(1, vehicleId);

            int updated =
                    updatePs.executeUpdate();


            /*
             * Make sure stock was actually reduced
             */
            if (updated != 1) {

                con.rollback();

                response.sendRedirect(
                        "bookVehicle.jsp?error=stock"
                );

                return;
            }


            /*
             * Everything successful
             */
            con.commit();


            /*
             * Return customer to dashboard
             */
            response.sendRedirect(
                    "customerDashboard.jsp?booking=success"
            );


        } catch (Exception e) {

            e.printStackTrace();

            /*
             * Rollback if anything fails
             */
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
                    "<html><body>"
            );

            response.getWriter().println(
                    "<h2>Booking Error</h2>"
            );

            response.getWriter().println(
                    "<p>"
                    + e.getMessage()
                    + "</p>"
            );

            response.getWriter().println(
                    "<br>"
            );

            response.getWriter().println(
                    "<a href='bookVehicle.jsp'>"
                    + "Back to Vehicles"
                    + "</a>"
            );

            response.getWriter().println(
                    "</body></html>"
            );


        } finally {


            /*
             * Close ResultSet
             */
            try {

                if (rs != null) {
                    rs.close();
                }

            } catch (Exception ignored) {
            }


            /*
             * Close stock statement
             */
            try {

                if (stockPs != null) {
                    stockPs.close();
                }

            } catch (Exception ignored) {
            }


            /*
             * Close insert statement
             */
            try {

                if (insertPs != null) {
                    insertPs.close();
                }

            } catch (Exception ignored) {
            }


            /*
             * Close update statement
             */
            try {

                if (updatePs != null) {
                    updatePs.close();
                }

            } catch (Exception ignored) {
            }


            /*
             * Close connection
             */
            try {

                if (con != null) {

                    con.setAutoCommit(true);

                    con.close();
                }

            } catch (Exception ignored) {
            }

        }
    }


    /*
     * Prevent direct GET request
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                "bookVehicle.jsp"
        );
    }
}