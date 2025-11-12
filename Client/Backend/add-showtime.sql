-- Script để thêm suất chiếu mẫu
-- Chạy script này trong MySQL để thêm suất chiếu test

-- Lưu ý: Cần thay đổi các ID sau theo dữ liệu thực tế trong database của bạn
-- 1. Kiểm tra movie_id có sẵn
-- 2. Kiểm tra cinema_id có sẵn  
-- 3. Kiểm tra room_id có sẵn (phải thuộc cinema_id)

-- Ví dụ: Thêm suất chiếu cho ngày hôm nay và ngày mai
-- Thay đổi các giá trị sau:
-- @movie_id: ID của phim (ví dụ: 1)
-- @cinema_id: ID của rạp (ví dụ: 1)
-- @room_id: ID của phòng chiếu (ví dụ: 1)
-- @price: Giá vé (ví dụ: 80000)

-- Thêm suất chiếu cho hôm nay
INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
VALUES 
-- Suất sáng
(1, 1, 1, CURDATE(), '09:00:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, CURDATE(), '11:30:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),

-- Suất chiều
(1, 1, 1, CURDATE(), '14:00:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, CURDATE(), '16:30:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),

-- Suất tối
(1, 1, 1, CURDATE(), '19:00:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, CURDATE(), '21:30:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW());

-- Thêm suất chiếu cho ngày mai
INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
VALUES 
(1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:30:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:30:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:00:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW()),
(1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:30:00', 80000, 70, 70, 'AVAILABLE', NOW(), NOW());

-- Kiểm tra dữ liệu đã thêm
SELECT 
    s.id,
    m.title as movie_title,
    c.name as cinema_name,
    r.room_name,
    s.show_date,
    s.show_time,
    s.price,
    s.available_seats,
    s.total_seats,
    s.status
FROM showtimes s
JOIN movies m ON s.movie_id = m.id
JOIN cinemas c ON s.cinema_id = c.id
JOIN cinema_rooms r ON s.room_id = r.id
ORDER BY s.show_date, s.show_time;



