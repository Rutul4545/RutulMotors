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

import Dao.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // ==========================================
        // GET FORM DATA
        // ==========================================

        String fullName =
                request.getParameter("full_name");

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirm_password");


        // ==========================================
        // BASIC VALIDATION
        // ==========================================

        if (fullName == null ||
            email == null ||
            password == null ||
            confirmPassword == null) {

            response.sendRedirect(
                "register.html?error=Please+fill+all+fields"
            );

            return;
        }


        fullName =
                fullName.trim();

        email =
                email.trim();


        if (fullName.isEmpty() ||
            email.isEmpty() ||
            password.isEmpty() ||
            confirmPassword.isEmpty()) {

            response.sendRedirect(
                "register.html?error=Please+fill+all+fields"
            );

            return;
        }


        // ==========================================
        // PASSWORD MATCH
        // ==========================================

        if (!password.equals(confirmPassword)) {

            response.sendRedirect(
                "register.html?error=Passwords+do+not+match"
            );

            return;
        }


        // ==========================================
        // DATABASE
        // ==========================================

        Connection con = null;

        PreparedStatement checkPs = null;

        PreparedStatement insertPs = null;

        ResultSet rs = null;


        try {


            con =
                DBConnection.getConnection();


            // ======================================
            // CHECK EMAIL
            // ======================================

            String checkSql =
                "SELECT user_id " +
                "FROM users " +
                "WHERE email = ?";


            checkPs =
                con.prepareStatement(checkSql);


            checkPs.setString(
                1,
                email
            );


            rs =
                checkPs.executeQuery();


            if (rs.next()) {

                response.sendRedirect(
                    "register.html?error=Email+already+registered"
                );

                return;
            }


            // ======================================
            // INSERT CUSTOMER
            // ======================================

            String insertSql =
                "INSERT INTO users " +
                "(full_name, email, password, role) " +
                "VALUES (?, ?, ?, 'CUSTOMER')";


            insertPs =
                con.prepareStatement(insertSql);


            insertPs.setString(
                1,
                fullName
            );


            insertPs.setString(
                2,
                email
            );


            insertPs.setString(
                3,
                password
            );


            insertPs.executeUpdate();


            // ======================================
            // SUCCESS
            // ======================================

            response.sendRedirect(
                "login.html?registered=true"
            );


        } catch (Exception e) {

            e.printStackTrace();


            response.setContentType(
                "text/html;charset=UTF-8"
            );


            response.getWriter().println(
                "<h2>Registration Error</h2>"
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
                "<a href='register.html'>" +
                "Back to Registration" +
                "</a>"
            );


        } finally {


            try {

                if (rs != null) {

                    rs.close();
                }

            } catch (Exception ignored) {
            }


            try {

                if (checkPs != null) {

                    checkPs.close();
                }

            } catch (Exception ignored) {
            }


            try {

                if (insertPs != null) {

                    insertPs.close();
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
            "register.html"
        );
    }

}
