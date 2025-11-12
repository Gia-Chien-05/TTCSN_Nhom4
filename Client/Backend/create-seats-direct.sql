-- Script tạo ghế cho phòng chiếu
-- Phòng 1: IMAX 1 - 15 hàng x 20 ghế = 300 ghế
-- Hàng A-B là VIP

-- Hàng A (VIP)
INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at) VALUES
(1, 'A', 1, 'VIP', NOW(), NOW()), (1, 'A', 2, 'VIP', NOW(), NOW()), (1, 'A', 3, 'VIP', NOW(), NOW()), (1, 'A', 4, 'VIP', NOW(), NOW()), (1, 'A', 5, 'VIP', NOW(), NOW()),
(1, 'A', 6, 'VIP', NOW(), NOW()), (1, 'A', 7, 'VIP', NOW(), NOW()), (1, 'A', 8, 'VIP', NOW(), NOW()), (1, 'A', 9, 'VIP', NOW(), NOW()), (1, 'A', 10, 'VIP', NOW(), NOW()),
(1, 'A', 11, 'VIP', NOW(), NOW()), (1, 'A', 12, 'VIP', NOW(), NOW()), (1, 'A', 13, 'VIP', NOW(), NOW()), (1, 'A', 14, 'VIP', NOW(), NOW()), (1, 'A', 15, 'VIP', NOW(), NOW()),
(1, 'A', 16, 'VIP', NOW(), NOW()), (1, 'A', 17, 'VIP', NOW(), NOW()), (1, 'A', 18, 'VIP', NOW(), NOW()), (1, 'A', 19, 'VIP', NOW(), NOW()), (1, 'A', 20, 'VIP', NOW(), NOW());

-- Hàng B (VIP)
INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at) VALUES
(1, 'B', 1, 'VIP', NOW(), NOW()), (1, 'B', 2, 'VIP', NOW(), NOW()), (1, 'B', 3, 'VIP', NOW(), NOW()), (1, 'B', 4, 'VIP', NOW(), NOW()), (1, 'B', 5, 'VIP', NOW(), NOW()),
(1, 'B', 6, 'VIP', NOW(), NOW()), (1, 'B', 7, 'VIP', NOW(), NOW()), (1, 'B', 8, 'VIP', NOW(), NOW()), (1, 'B', 9, 'VIP', NOW(), NOW()), (1, 'B', 10, 'VIP', NOW(), NOW()),
(1, 'B', 11, 'VIP', NOW(), NOW()), (1, 'B', 12, 'VIP', NOW(), NOW()), (1, 'B', 13, 'VIP', NOW(), NOW()), (1, 'B', 14, 'VIP', NOW(), NOW()), (1, 'B', 15, 'VIP', NOW(), NOW()),
(1, 'B', 16, 'VIP', NOW(), NOW()), (1, 'B', 17, 'VIP', NOW(), NOW()), (1, 'B', 18, 'VIP', NOW(), NOW()), (1, 'B', 19, 'VIP', NOW(), NOW()), (1, 'B', 20, 'VIP', NOW(), NOW());

-- Hàng C-G (NORMAL) - Tạo bằng stored procedure đơn giản hơn
-- Tạo một script Python/Node.js sẽ dễ hơn, nhưng giờ tạo bằng SQL đơn giản



