CREATE DATABASE IF NOT EXISTS showroom_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE showroom_management;

CREATE TABLE IF NOT EXISTS users (
    user_id INT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id INT NOT NULL AUTO_INCREMENT,
    vehicle_name VARCHAR(150) NOT NULL,
    vehicle_type VARCHAR(100) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    PRIMARY KEY (vehicle_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT NOT NULL AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    customer_id INT NOT NULL,
    booking_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    PRIMARY KEY (booking_id),
    KEY idx_bookings_customer (customer_id),
    KEY idx_bookings_vehicle (vehicle_id),
    CONSTRAINT fk_bookings_vehicle
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id),
    CONSTRAINT fk_bookings_customer
        FOREIGN KEY (customer_id) REFERENCES users (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS sales (
    sale_id INT NOT NULL AUTO_INCREMENT,
    booking_id INT NULL,
    vehicle_id INT NOT NULL,
    customer_id INT NOT NULL,
    sale_date DATE NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    PRIMARY KEY (sale_id),
    UNIQUE KEY uq_sales_booking (booking_id),
    KEY idx_sales_vehicle (vehicle_id),
    KEY idx_sales_customer (customer_id),
    CONSTRAINT fk_sales_booking
        FOREIGN KEY (booking_id) REFERENCES bookings (booking_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_sales_vehicle
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id),
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_id) REFERENCES users (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
