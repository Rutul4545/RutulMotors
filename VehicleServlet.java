package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Dao.DBConnection;

@WebServlet("/VehicleServlet")
public class VehicleServlet extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            Connection con = DBConnection.getConnection();

            // ADD VEHICLE
            if ("add".equals(action)) {

                String vehicleName =
                        request.getParameter("vehicle_name");

                String vehicleType =
                        request.getParameter("vehicle_type");

                String brand =
                        request.getParameter("brand");

                double price =
                        Double.parseDouble(
                                request.getParameter("price")
                        );

                int stock =
                        Integer.parseInt(
                                request.getParameter("stock")
                        );

                String sql =
                        "INSERT INTO vehicles " +
                        "(vehicle_name, vehicle_type, brand, price, stock) " +
                        "VALUES (?, ?, ?, ?, ?)";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, vehicleName);
                ps.setString(2, vehicleType);
                ps.setString(3, brand);
                ps.setDouble(4, price);
                ps.setInt(5, stock);

                ps.executeUpdate();

                ps.close();
            }


            // UPDATE VEHICLE
            else if ("update".equals(action)) {

                int vehicleId =
                        Integer.parseInt(
                                request.getParameter("vehicle_id")
                        );

                String vehicleName =
                        request.getParameter("vehicle_name");

                String vehicleType =
                        request.getParameter("vehicle_type");

                String brand =
                        request.getParameter("brand");

                double price =
                        Double.parseDouble(
                                request.getParameter("price")
                        );

                int stock =
                        Integer.parseInt(
                                request.getParameter("stock")
                        );

                String sql =
                        "UPDATE vehicles SET " +
                        "vehicle_name=?, " +
                        "vehicle_type=?, " +
                        "brand=?, " +
                        "price=?, " +
                        "stock=? " +
                        "WHERE vehicle_id=?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setString(1, vehicleName);
                ps.setString(2, vehicleType);
                ps.setString(3, brand);
                ps.setDouble(4, price);
                ps.setInt(5, stock);
                ps.setInt(6, vehicleId);

                ps.executeUpdate();

                ps.close();
            }

            con.close();

            response.sendRedirect("vehicles.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                "<h2>Vehicle Operation Error</h2>"
                + "<p>"
                + e.getMessage()
                + "</p>"
            );
        }
    }


    // DELETE VEHICLE

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action =
                request.getParameter("action");

        if ("delete".equals(action)) {

            try {

                int vehicleId =
                        Integer.parseInt(
                                request.getParameter("vehicle_id")
                        );

                Connection con =
                        DBConnection.getConnection();

                String sql =
                        "DELETE FROM vehicles " +
                        "WHERE vehicle_id=?";

                PreparedStatement ps =
                        con.prepareStatement(sql);

                ps.setInt(1, vehicleId);

                ps.executeUpdate();

                ps.close();
                con.close();

                response.sendRedirect("vehicles.jsp");

            } catch (Exception e) {

                e.printStackTrace();

                response.setContentType(
                        "text/html"
                );

                response.getWriter().println(
                    "<h2>Delete Error</h2>"
                    + "<p>"
                    + e.getMessage()
                    + "</p>"
                );
            }

        } else {

            response.sendRedirect("vehicles.jsp");
        }
    }
}