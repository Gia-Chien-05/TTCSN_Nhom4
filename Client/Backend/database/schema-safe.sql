-- Database Schema cho Website Bán Vé Xem Phim CineMax (Safe Version)
-- MySQL 8.0+ - Có thể chạy lại nhiều lần mà không bị lỗi

CREATE DATABASE IF NOT EXISTS cinemax_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cinemax_db;

-- Bảng Người dùng
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    address TEXT,
    membership_type ENUM('NONE', 'SILVER', 'GOLD', 'PLATINUM') DEFAULT 'NONE',
    membership_expiry_date DATE,
    points INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_membership (membership_type)
);

-- Bảng Rạp Chiếu
CREATE TABLE IF NOT EXISTS cinemas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    district VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    opening_hours VARCHAR(100),
    price_range VARCHAR(50),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    image_url VARCHAR(500),
    status ENUM('OPEN', 'CLOSED', 'MAINTENANCE') DEFAULT 'OPEN',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_city (city),
    INDEX idx_status (status)
);

-- Bảng Tiện ích Rạp
CREATE TABLE IF NOT EXISTS cinema_features (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cinema_id BIGINT NOT NULL,
    feature_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (cinema_id) REFERENCES cinemas(id) ON DELETE CASCADE,
    INDEX idx_cinema (cinema_id)
);

-- Bảng Phòng Chiếu
CREATE TABLE IF NOT EXISTS cinema_rooms (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cinema_id BIGINT NOT NULL,
    room_name VARCHAR(50) NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    total_rows INT NOT NULL,
    seats_per_row INT NOT NULL,
    vip_rows VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cinema_id) REFERENCES cinemas(id) ON DELETE CASCADE,
    INDEX idx_cinema (cinema_id)
);

-- Bảng Phim
CREATE TABLE IF NOT EXISTS movies (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    imdb_id VARCHAR(20) UNIQUE,
    title VARCHAR(200) NOT NULL,
    title_vietnamese VARCHAR(200),
    description TEXT,
    genre VARCHAR(200),
    director VARCHAR(100),
    actors TEXT,
    release_date DATE,
    duration INT,
    rating DECIMAL(3, 1),
    language VARCHAR(50),
    country VARCHAR(50),
    poster_url VARCHAR(500),
    trailer_url VARCHAR(500),
    status ENUM('COMING_SOON', 'NOW_SHOWING', 'ENDED') DEFAULT 'NOW_SHOWING',
    price DECIMAL(10, 2) NOT NULL,
    vip_price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_title (title),
    INDEX idx_imdb (imdb_id)
);

-- Bảng Suất Chiếu
CREATE TABLE IF NOT EXISTS showtimes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    movie_id BIGINT NOT NULL,
    cinema_id BIGINT NOT NULL,
    room_id BIGINT NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    available_seats INT NOT NULL,
    total_seats INT NOT NULL,
    status ENUM('AVAILABLE', 'FULL', 'CANCELLED') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (cinema_id) REFERENCES cinemas(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES cinema_rooms(id) ON DELETE CASCADE,
    INDEX idx_movie (movie_id),
    INDEX idx_cinema (cinema_id),
    INDEX idx_date_time (show_date, show_time),
    INDEX idx_status (status)
);

-- Bảng Ghế (Seats)
CREATE TABLE IF NOT EXISTS seats (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    room_id BIGINT NOT NULL,
    `row_number` VARCHAR(5) NOT NULL,
    seat_number INT NOT NULL,
    seat_type ENUM('NORMAL', 'VIP', 'COUPLE') DEFAULT 'NORMAL',
    position_x INT,
    position_y INT,
    FOREIGN KEY (room_id) REFERENCES cinema_rooms(id) ON DELETE CASCADE,
    UNIQUE KEY unique_seat (room_id, `row_number`, seat_number),
    INDEX idx_room (room_id)
);

-- Bảng Đặt Vé
CREATE TABLE IF NOT EXISTS bookings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_code VARCHAR(20) UNIQUE NOT NULL,
    user_id BIGINT,
    showtime_id BIGINT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    final_amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('MOMO', 'ZALOPAY', 'BANKING', 'CASH') NOT NULL,
    payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    booking_status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_date TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_showtime (showtime_id),
    INDEX idx_booking_code (booking_code),
    INDEX idx_status (booking_status)
);

-- Bảng Chi Tiết Đặt Vé (Ghế đã đặt)
CREATE TABLE IF NOT EXISTS booking_seats (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id BIGINT NOT NULL,
    seat_id BIGINT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE CASCADE,
    INDEX idx_booking (booking_id),
    INDEX idx_seat (seat_id)
);

-- Bảng Ghế Đã Đặt trong Suất Chiếu (để tối ưu query)
CREATE TABLE IF NOT EXISTS showtime_seats (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    showtime_id BIGINT NOT NULL,
    seat_id BIGINT NOT NULL,
    status ENUM('AVAILABLE', 'BOOKED', 'RESERVED', 'BLOCKED') DEFAULT 'AVAILABLE',
    booking_id BIGINT,
    reserved_until TIMESTAMP NULL,
    FOREIGN KEY (showtime_id) REFERENCES showtimes(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE SET NULL,
    UNIQUE KEY unique_showtime_seat (showtime_id, seat_id),
    INDEX idx_showtime (showtime_id),
    INDEX idx_status (status)
);

-- Bảng Khuyến Mãi
CREATE TABLE IF NOT EXISTS promotions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    min_amount DECIMAL(10, 2),
    max_discount DECIMAL(10, 2),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    usage_limit INT,
    used_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_dates (start_date, end_date)
);

-- Bảng Lịch Sử Giao Dịch
CREATE TABLE IF NOT EXISTS transactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id BIGINT NOT NULL,
    transaction_code VARCHAR(50) UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('MOMO', 'ZALOPAY', 'BANKING', 'CASH') NOT NULL,
    status ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_date TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    INDEX idx_booking (booking_id),
    INDEX idx_transaction_code (transaction_code),
    INDEX idx_status (status)
);

-- Insert dữ liệu mẫu (chỉ insert nếu chưa có)
INSERT IGNORE INTO cinemas (id, name, address, city, district, phone, opening_hours, price_range, latitude, longitude, status) VALUES
(1, 'CGV Vincom Center', '72 Lê Thánh Tôn, Quận 1, TP.HCM', 'Hồ Chí Minh', 'Quận 1', '1900 6017', '8:00 - 24:00', '75,000 - 150,000 VNĐ', 10.7769, 106.7009, 'OPEN'),
(2, 'Lotte Cinema Đà Nẵng', 'Công Viên Phần Mềm, Quận Hải Châu, Đà Nẵng', 'Đà Nẵng', 'Quận Hải Châu', '1900 2224', '8:30 - 23:30', '70,000 - 140,000 VNĐ', 16.0544, 108.2022, 'OPEN'),
(3, 'BHD Star Cineplex', '191 Nguyễn Văn Linh, Quận Bình Thạnh, TP.HCM', 'Hồ Chí Minh', 'Quận Bình Thạnh', '1900 2099', '9:00 - 24:00', '80,000 - 160,000 VNĐ', 10.8014, 106.7215, 'OPEN');

-- Tiện ích rạp
INSERT IGNORE INTO cinema_features (cinema_id, feature_name) VALUES
(1, 'IMAX'), (1, '4DX'), (1, 'Dolby Atmos'), (1, 'VIP'), (1, 'Parking'),
(2, 'Dolby Atmos'), (2, 'VIP'), (2, '3D'), (2, 'Parking'),
(3, 'Starium'), (3, 'Dolby Atmos'), (3, 'VIP'), (3, 'Food Court');

-- Phòng chiếu mẫu
INSERT IGNORE INTO cinema_rooms (id, cinema_id, room_name, room_type, capacity, total_rows, seats_per_row, vip_rows) VALUES
(1, 1, 'IMAX 1', 'IMAX', 300, 15, 20, 'A,B'),
(2, 1, 'Standard 1', 'Standard', 200, 10, 20, ''),
(3, 2, 'Lotte 1', 'Standard', 250, 12, 21, 'A,B,C'),
(4, 3, 'Starium 1', 'Starium', 350, 18, 20, 'A,B,C');

-- Phim mẫu
INSERT IGNORE INTO movies (id, imdb_id, title, title_vietnamese, description, genre, director, release_date, duration, rating, price, vip_price, status) VALUES
(1, 'tt1375666', 'Inception', 'Kẻ Trộm Giấc Mơ', 'A mind-bending thriller about dream infiltration', 'Sci-Fi, Action', 'Christopher Nolan', '2010-07-16', 148, 8.8, 85000, 120000, 'NOW_SHOWING'),
(2, 'tt0816692', 'Interstellar', 'Hố Đen Vũ Trụ', 'A journey through space and time', 'Sci-Fi, Drama', 'Christopher Nolan', '2014-11-07', 169, 8.6, 85000, 120000, 'NOW_SHOWING'),
(3, 'tt0133093', 'The Matrix', 'Ma Trận', 'A computer hacker learns about the true nature of reality', 'Action, Sci-Fi', 'Lana Wachowski', '1999-03-31', 136, 8.7, 75000, 110000, 'NOW_SHOWING');

