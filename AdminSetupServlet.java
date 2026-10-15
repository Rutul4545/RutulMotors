package controller;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Dao.DBConnection;

@WebServlet("/AdminSetupServlet")
public class AdminSetupServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String SETUP_LOCK = "rutulmotors_first_admin_setup";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLocalRequest(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (hasAdmin(con)) {
                response.sendRedirect("login.html?setup=unavailable");
                return;
            }

            response.sendRedirect("adminSetup.html");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Could not check admin setup. Check the database connection and try again."
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isLocalRequest(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (fullName == null || email == null || password == null
                || confirmPassword == null
                || fullName.trim().isEmpty() || email.trim().isEmpty()
                || password.length() < 12 || !password.equals(confirmPassword)) {
            response.sendRedirect("adminSetup.html?error=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            boolean lockAcquired;
            try (PreparedStatement lockStatement =
                    con.prepareStatement("SELECT GET_LOCK(?, 10)")) {
                lockStatement.setString(1, SETUP_LOCK);
                try (ResultSet lockResult = lockStatement.executeQuery()) {
                    lockAcquired = lockResult.next() && lockResult.getInt(1) == 1;
                }
            }

            if (!lockAcquired) {
                response.sendRedirect("adminSetup.html?error=busy");
                return;
            }

            con.setAutoCommit(false);
            if (hasAdmin(con)) {
                con.rollback();
                response.sendRedirect("login.html?setup=unavailable");
                return;
            }

            try (PreparedStatement emailStatement = con.prepareStatement(
                    "SELECT user_id FROM users WHERE email = ?")) {
                emailStatement.setString(1, email.trim());
                try (ResultSet emailResult = emailStatement.executeQuery()) {
                    if (emailResult.next()) {
                        con.rollback();
                        response.sendRedirect("adminSetup.html?error=email");
                        return;
                    }
                }
            }

            try (PreparedStatement insertStatement = con.prepareStatement(
                    "INSERT INTO users (full_name, email, password, role) "
                            + "VALUES (?, ?, ?, 'ADMIN')")) {
                insertStatement.setString(1, fullName.trim());
                insertStatement.setString(2, email.trim());
                insertStatement.setString(3, password);
                insertStatement.executeUpdate();
            }

            con.commit();
            response.sendRedirect("login.html?setup=complete");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Admin setup failed. Check the database connection and try again."
            );
        }
    }

    private boolean hasAdmin(Connection con) throws SQLException {
        try (Statement statement = con.createStatement();
             ResultSet result = statement.executeQuery(
                     "SELECT user_id FROM users WHERE role = 'ADMIN' LIMIT 1")) {
            return result.next();
        }
    }

    private boolean isLocalRequest(HttpServletRequest request) {
        try {
            return InetAddress.getByName(request.getRemoteAddr()).isLoopbackAddress();
        } catch (UnknownHostException e) {
            return false;
        }
    }
}
