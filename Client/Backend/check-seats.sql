-- Script kiểm tra dữ liệu seats
USE cinemax_db;

-- Tổng số ghế
SELECT COUNT(*) as 'Tổng số ghế' FROM seats;

-- Phân bổ theo phòng
SELECT 
    r.id as 'Room ID',
    r.room_name as 'Tên phòng',
    c.name as 'Rạp',
    COUNT(s.id) as 'Tổng ghế',
    COUNT(CASE WHEN s.seat_type = 'VIP' THEN 1 END) as 'VIP',
    COUNT(CASE WHEN s.seat_type = 'NORMAL' THEN 1 END) as 'Normal'
FROM cinema_rooms r
LEFT JOIN cinemas c ON r.cinema_id = c.id
LEFT JOIN seats s ON r.id = s.room_id
GROUP BY r.id, r.room_name, c.name
ORDER BY r.id;

-- Xem 10 ghế đầu tiên
SELECT 
    id,
    room_id,
    row_number,
    seat_number,
    seat_type
FROM seats
ORDER BY id
LIMIT 10;

-- Kiểm tra theo từng phòng
SELECT 
    room_id,
    row_number,
    COUNT(*) as 'Số ghế',
    seat_type
FROM seats
WHERE room_id = 1
GROUP BY room_id, row_number, seat_type
ORDER BY row_number
LIMIT 10;



