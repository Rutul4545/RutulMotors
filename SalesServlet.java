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

@WebServlet("/SalesServlet")
public class SalesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("login.html");
            return;
        }

        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "customerDashboard.jsp"
            );

            return;
        }

        String vehicleParam =
                request.getParameter("vehicle_id");

        String customerParam =
                request.getParameter("customer_id");

        String amountParam =
                request.getParameter("amount");

        if (vehicleParam == null ||
            customerParam == null ||
            amountParam == null ||
            vehicleParam.trim().isEmpty() ||
            customerParam.trim().isEmpty() ||
            amountParam.trim().isEmpty()) {

            response.sendRedirect(
                    "sales.jsp?error=Please+fill+all+fields"
            );

            return;
        }

        int vehicleId;
        int customerId;
        double amount;

        try {

            vehicleId =
                    Integer.parseInt(
                            vehicleParam.trim()
                    );

            customerId =
                    Integer.parseInt(
                            customerParam.trim()
                    );

            amount =
                    Double.parseDouble(
                            amountParam.trim()
                    );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "sales.jsp?error=Invalid+input"
            );

            return;
        }

        if (amount <= 0) {

            response.sendRedirect(
                    "sales.jsp?error=Sale+amount+must+be+greater+than+zero"
            );

            return;
        }

        Connection con = null;

        PreparedStatement stockPs = null;
        PreparedStatement salePs = null;
        PreparedStatement updatePs = null;

        ResultSet rs = null;

        try {

            con =
                    DBConnection.getConnection();

            con.setAutoCommit(false);

            String stockSql =
                    "SELECT stock " +
                    "FROM vehicles " +
                    "WHERE vehicle_id = ? " +
                    "FOR UPDATE";

            stockPs =
                    con.prepareStatement(stockSql);

            stockPs.setInt(
                    1,
                    vehicleId
            );

            rs =
                    stockPs.executeQuery();

            if (!rs.next()) {

                con.rollback();

                response.sendRedirect(
                        "sales.jsp?error=Vehicle+not+found"
                );

                return;
            }

            int stock =
                    rs.getInt("stock");

            if (stock <= 0) {

                con.rollback();

                response.sendRedirect(
                        "sales.jsp?error=Vehicle+is+out+of+stock"
                );

                return;
            }

            String saleSql =
                    "INSERT INTO sales " +
                    "(vehicle_id, customer_id, sale_date, amount) " +
                    "VALUES (?, ?, CURDATE(), ?)";

            salePs =
                    con.prepareStatement(saleSql);

            salePs.setInt(
                    1,
                    vehicleId
            );

            salePs.setInt(
                    2,
                    customerId
            );

            salePs.setDouble(
                    3,
                    amount
            );

            int saleInserted =
                    salePs.executeUpdate();

            if (saleInserted != 1) {

                con.rollback();

                response.sendRedirect(
                        "sales.jsp?error=Unable+to+record+sale"
                );

                return;
            }

            String updateSql =
                    "UPDATE vehicles " +
                    "SET stock = stock - 1 " +
                    "WHERE vehicle_id = ? " +
                    "AND stock > 0";

            updatePs =
                    con.prepareStatement(updateSql);

            updatePs.setInt(
                    1,
                    vehicleId
            );

            int updated =
                    updatePs.executeUpdate();

            if (updated != 1) {

                con.rollback();

                response.sendRedirect(
                        "sales.jsp?error=Unable+to+update+vehicle+stock"
                );

                return;
            }

            con.commit();

            response.sendRedirect(
                    "sales.jsp?success=true"
            );

        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception ignored) {
            }

            response.sendRedirect(
                    "sales.jsp?error=Sale+could+not+be+completed"
            );

        } finally {

            try {

                if (rs != null) {
                    rs.close();
                }

            } catch (Exception ignored) {
            }

            try {

                if (stockPs != null) {
                    stockPs.close();
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

                if (updatePs != null) {
                    updatePs.close();
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
                "sales.jsp"
        );
    }
}