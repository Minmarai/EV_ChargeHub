CREATE DATABASE IF NOT EXISTS chargehub_nepal;
USE chargehub_nepal;

DROP TABLE IF EXISTS contact_messages;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS slots;
DROP TABLE IF EXISTS stations;
DROP TABLE IF EXISTS districts;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       full_name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       phone VARCHAR(20) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       vehicle_number VARCHAR(30),
                       address VARCHAR(255),
                       role ENUM('admin', 'station_manager', 'user') NOT NULL DEFAULT 'user',
                       status ENUM('pending', 'active', 'inactive') NOT NULL DEFAULT 'pending',
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE districts (
                           district_id INT AUTO_INCREMENT PRIMARY KEY,
                           district_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE stations (
                          station_id INT AUTO_INCREMENT PRIMARY KEY,
                          station_name VARCHAR(120) NOT NULL,
                          district_id INT NOT NULL,
                          manager_id INT,
                          address VARCHAR(255) NOT NULL,
                          contact_number VARCHAR(20),
                          charger_type VARCHAR(50) NOT NULL,
                          total_ports INT NOT NULL,
                          opening_time TIME NOT NULL,
                          closing_time TIME NOT NULL,
                          price_per_hour DECIMAL(8,2),
                          status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
                          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (district_id) REFERENCES districts(district_id),
                          FOREIGN KEY (manager_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE slots (
                       slot_id INT AUTO_INCREMENT PRIMARY KEY,
                       station_id INT NOT NULL,
                       slot_date DATE NOT NULL,
                       start_time TIME NOT NULL,
                       end_time TIME NOT NULL,
                       availability_status ENUM('available', 'booked', 'inactive') NOT NULL DEFAULT 'available',
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE
);

CREATE TABLE bookings (
                          booking_id INT AUTO_INCREMENT PRIMARY KEY,
                          user_id INT NOT NULL,
                          station_id INT NOT NULL,
                          slot_id INT NOT NULL,
                          vehicle_number VARCHAR(30) NOT NULL,
                          booking_status ENUM('pending', 'confirmed', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
                          booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                          notes VARCHAR(255),
                          FOREIGN KEY (user_id) REFERENCES users(user_id),
                          FOREIGN KEY (station_id) REFERENCES stations(station_id),
                          FOREIGN KEY (slot_id) REFERENCES slots(slot_id)
);

CREATE TABLE payments (
                          payment_id INT AUTO_INCREMENT PRIMARY KEY,
                          booking_id INT NOT NULL UNIQUE,
                          user_id INT NOT NULL,
                          amount DECIMAL(10,2) NOT NULL,
                          payment_method ENUM('cash', 'esewa', 'khalti', 'card') NOT NULL DEFAULT 'cash',
                          payment_status ENUM('pending', 'paid', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
                          transaction_reference VARCHAR(100),
                          payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                          remarks VARCHAR(255),
                          FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
                          FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE favorites (
                           favorite_id INT AUTO_INCREMENT PRIMARY KEY,
                           user_id INT NOT NULL,
                           station_id INT NOT NULL,
                           created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                           FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE,
                           UNIQUE (user_id, station_id)
);

CREATE TABLE reviews (
                         review_id INT AUTO_INCREMENT PRIMARY KEY,
                         user_id INT NOT NULL,
                         station_id INT NOT NULL,
                         rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
                         comment TEXT,
                         review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                         status ENUM('visible', 'hidden') NOT NULL DEFAULT 'visible',
                         FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                         FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE
);

CREATE TABLE contact_messages (
                                  message_id INT AUTO_INCREMENT PRIMARY KEY,
                                  name VARCHAR(100) NOT NULL,
                                  email VARCHAR(100) NOT NULL,
                                  subject VARCHAR(150) NOT NULL,
                                  message TEXT NOT NULL,
                                  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                  status ENUM('unread', 'read') NOT NULL DEFAULT 'unread'
);

INSERT INTO districts (district_name) VALUES
                                          ('Kathmandu'),('Lalitpur'),('Bhaktapur'),('Chitwan'),('Pokhara'),('Butwal'),('Dharan'),('Biratnagar');

-- Password for all sample users is: Password123
INSERT INTO users (full_name,email,phone,password_hash,vehicle_number,address,role,status) VALUES
                                                                                               ('System Admin','admin@chargehub.com','9800000000','$2a$10$8xKDn9Pl03hOX0XtHNuCXet/1xtKEprcFlz7xEFCVDIuq14B5Xi/G',NULL,'Kathmandu','admin','active'),
                                                                                               ('Ramesh Shrestha','manager@chargehub.com','9811111111','$2a$10$8xKDn9Pl03hOX0XtHNuCXet/1xtKEprcFlz7xEFCVDIuq14B5Xi/G',NULL,'Lalitpur','station_manager','active'),
                                                                                               ('Sita Thapa','sita@gmail.com','9822222222','$2a$10$8xKDn9Pl03hOX0XtHNuCXet/1xtKEprcFlz7xEFCVDIuq14B5Xi/G','BA 12 PA 3456','Kathmandu','user','active');

INSERT INTO stations (station_name,district_id,manager_id,address,contact_number,charger_type,total_ports,opening_time,closing_time,price_per_hour,status) VALUES
                                                                                                                                                               ('Green Charge Kathmandu',1,2,'New Baneshwor, Kathmandu','014444444','Fast Charger',6,'06:00:00','22:00:00',250.00,'active'),
                                                                                                                                                               ('EV Power Lalitpur',2,2,'Pulchowk, Lalitpur','015555555','DC Charger',4,'07:00:00','21:00:00',220.00,'active');

INSERT INTO slots (station_id,slot_date,start_time,end_time,availability_status) VALUES
                                                                                     (1,CURDATE(),'09:00:00','10:00:00','available'),
                                                                                     (1,CURDATE(),'10:00:00','11:00:00','available'),
                                                                                     (2,CURDATE(),'14:00:00','15:00:00','available');

ALTER TABLE stations ADD COLUMN active_days VARCHAR(50) DEFAULT 'Mon,Tue,Wed,Thu,Fri,Sat';

select * from bookings;