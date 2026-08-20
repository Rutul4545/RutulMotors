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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation
        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {

            response.sendRedirect("login.html?error=empty");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            // Get database connection
            con = DBConnection.getConnection();

            /*
             * Check login details and get the user's role.
             */
            String sql =
                    "SELECT user_id, full_name, email, role " +
                    "FROM users " +
                    "WHERE email = ? AND password = ?";

            ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();


            /*
             * LOGIN SUCCESS
             */
            if (rs.next()) {

                int userId =
                        rs.getInt("user_id");

                String fullName =
                        rs.getString("full_name");

                String userEmail =
                        rs.getString("email");

                String role =
                        rs.getString("role");


                /*
                 * Create session
                 */
                HttpSession session =
                        request.getSession();

                session.setAttribute(
                        "userId",
                        userId
                );

                session.setAttribute(
                        "fullName",
                        fullName
                );

                session.setAttribute(
                        "user",
                        userEmail
                );

                session.setAttribute(
                        "role",
                        role
                );


                /*
                 * ADMIN
                 *
                 * Admin goes to the
                 * admin dashboard.
                 */
                if ("ADMIN".equalsIgnoreCase(role)) {

                    response.sendRedirect(
                            "dashboard.jsp"
                    );

                }

                /*
                 * CUSTOMER
                 *
                 * Customer goes to the
                 * customer dashboard.
                 */
                else {

                    response.sendRedirect(
                            "customerDashboard.jsp"
                    );
                }

            }

            /*
             * LOGIN FAILED
             */
            else {

                response.sendRedirect(
                        "login.html?error=invalid"
                );
            }


        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                    "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                    "<html><body>"
            );

            response.getWriter().println(
                    "<h2>Database Connection Error</h2>"
            );

            response.getWriter().println(
                    "<p>"
                    + e.getMessage()
                    + "</p>"
            );

            response.getWriter().println(
                    "<br><a href='login.html'>Back to Login</a>"
            );

            response.getWriter().println(
                    "</body></html>"
            );

        } finally {

            /*
             * Close database resources
             */
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignored) {
            }

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


    /*
     * If someone directly opens
     * /LoginServlet in the browser,
     * send them to login page.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("login.html");
    }
}