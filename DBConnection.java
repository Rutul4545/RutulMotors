package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public class DBConnection {

    private static final Path CONFIG_FILE =
            Path.of(System.getProperty("user.home"), ".rutulmotors-db.properties");

    public static Connection getConnection() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC Driver not found!", e
            );
        }

        Properties config = new Properties();
        if (Files.isRegularFile(CONFIG_FILE)) {
            try (InputStream input = Files.newInputStream(CONFIG_FILE)) {
                config.load(input);
            } catch (IOException e) {
                throw new SQLException("Could not read database configuration.", e);
            }
        }

        String url = setting(config, "RUTUL_DB_URL", "url",
                "jdbc:mysql://localhost:3306/showroom_management"
                        + "?useSSL=false"
                        + "&allowPublicKeyRetrieval=true"
                        + "&serverTimezone=UTC");
        String user = setting(config, "RUTUL_DB_USER", "user", "root");
        String password = setting(config, "RUTUL_DB_PASSWORD", "password", null);
        if (password == null || password.isBlank()) {
            throw new SQLException(
                    "Database password is not configured. Set RUTUL_DB_PASSWORD "
                            + "or add a password to ~/.rutulmotors-db.properties."
            );
        }

        return DriverManager.getConnection(
                url,
                user,
                password
        );
    }

    private static String setting(
            Properties config,
            String environmentName,
            String propertyName,
            String defaultValue) {

        String environmentValue = System.getenv(environmentName);
        if (environmentValue != null && !environmentValue.isBlank()) {
            return environmentValue;
        }

        String propertyValue = config.getProperty(propertyName);
        if (propertyValue != null && !propertyValue.isBlank()) {
            return propertyValue;
        }

        return defaultValue;
    }
}