-- Script tạo tất cả ghế cho các phòng chiếu
-- Xóa dữ liệu cũ nếu có
TRUNCATE TABLE seats;

-- Phòng 1: IMAX 1 - 15 hàng (A-O) x 20 ghế = 300 ghế
-- Hàng A, B là VIP

-- Hàng A (VIP) - 20 ghế
INSERT INTO seats (room_id, row_number, seat_number, seat_type) VALUES
(1, 'A', 1, 'VIP'), (1, 'A', 2, 'VIP'), (1, 'A', 3, 'VIP'), (1, 'A', 4, 'VIP'), (1, 'A', 5, 'VIP'),
(1, 'A', 6, 'VIP'), (1, 'A', 7, 'VIP'), (1, 'A', 8, 'VIP'), (1, 'A', 9, 'VIP'), (1, 'A', 10, 'VIP'),
(1, 'A', 11, 'VIP'), (1, 'A', 12, 'VIP'), (1, 'A', 13, 'VIP'), (1, 'A', 14, 'VIP'), (1, 'A', 15, 'VIP'),
(1, 'A', 16, 'VIP'), (1, 'A', 17, 'VIP'), (1, 'A', 18, 'VIP'), (1, 'A', 19, 'VIP'), (1, 'A', 20, 'VIP');

-- Hàng B (VIP) - 20 ghế
INSERT INTO seats (room_id, row_number, seat_number, seat_type) VALUES
(1, 'B', 1, 'VIP'), (1, 'B', 2, 'VIP'), (1, 'B', 3, 'VIP'), (1, 'B', 4, 'VIP'), (1, 'B', 5, 'VIP'),
(1, 'B', 6, 'VIP'), (1, 'B', 7, 'VIP'), (1, 'B', 8, 'VIP'), (1, 'B', 9, 'VIP'), (1, 'B', 10, 'VIP'),
(1, 'B', 11, 'VIP'), (1, 'B', 12, 'VIP'), (1, 'B', 13, 'VIP'), (1, 'B', 14, 'VIP'), (1, 'B', 15, 'VIP'),
(1, 'B', 16, 'VIP'), (1, 'B', 17, 'VIP'), (1, 'B', 18, 'VIP'), (1, 'B', 19, 'VIP'), (1, 'B', 20, 'VIP');

-- Hàng C-O (NORMAL) - 13 hàng x 20 ghế = 260 ghế
INSERT INTO seats (room_id, row_number, seat_number, seat_type) VALUES
(1, 'C', 1, 'NORMAL'), (1, 'C', 2, 'NORMAL'), (1, 'C', 3, 'NORMAL'), (1, 'C', 4, 'NORMAL'), (1, 'C', 5, 'NORMAL'),
(1, 'C', 6, 'NORMAL'), (1, 'C', 7, 'NORMAL'), (1, 'C', 8, 'NORMAL'), (1, 'C', 9, 'NORMAL'), (1, 'C', 10, 'NORMAL'),
(1, 'C', 11, 'NORMAL'), (1, 'C', 12, 'NORMAL'), (1, 'C', 13, 'NORMAL'), (1, 'C', 14, 'NORMAL'), (1, 'C', 15, 'NORMAL'),
(1, 'C', 16, 'NORMAL'), (1, 'C', 17, 'NORMAL'), (1, 'C', 18, 'NORMAL'), (1, 'C', 19, 'NORMAL'), (1, 'C', 20, 'NORMAL'),
(1, 'D', 1, 'NORMAL'), (1, 'D', 2, 'NORMAL'), (1, 'D', 3, 'NORMAL'), (1, 'D', 4, 'NORMAL'), (1, 'D', 5, 'NORMAL'),
(1, 'D', 6, 'NORMAL'), (1, 'D', 7, 'NORMAL'), (1, 'D', 8, 'NORMAL'), (1, 'D', 9, 'NORMAL'), (1, 'D', 10, 'NORMAL'),
(1, 'D', 11, 'NORMAL'), (1, 'D', 12, 'NORMAL'), (1, 'D', 13, 'NORMAL'), (1, 'D', 14, 'NORMAL'), (1, 'D', 15, 'NORMAL'),
(1, 'D', 16, 'NORMAL'), (1, 'D', 17, 'NORMAL'), (1, 'D', 18, 'NORMAL'), (1, 'D', 19, 'NORMAL'), (1, 'D', 20, 'NORMAL'),
(1, 'E', 1, 'NORMAL'), (1, 'E', 2, 'NORMAL'), (1, 'E', 3, 'NORMAL'), (1, 'E', 4, 'NORMAL'), (1, 'E', 5, 'NORMAL'),
(1, 'E', 6, 'NORMAL'), (1, 'E', 7, 'NORMAL'), (1, 'E', 8, 'NORMAL'), (1, 'E', 9, 'NORMAL'), (1, 'E', 10, 'NORMAL'),
(1, 'E', 11, 'NORMAL'), (1, 'E', 12, 'NORMAL'), (1, 'E', 13, 'NORMAL'), (1, 'E', 14, 'NORMAL'), (1, 'E', 15, 'NORMAL'),
(1, 'E', 16, 'NORMAL'), (1, 'E', 17, 'NORMAL'), (1, 'E', 18, 'NORMAL'), (1, 'E', 19, 'NORMAL'), (1, 'E', 20, 'NORMAL'),
(1, 'F', 1, 'NORMAL'), (1, 'F', 2, 'NORMAL'), (1, 'F', 3, 'NORMAL'), (1, 'F', 4, 'NORMAL'), (1, 'F', 5, 'NORMAL'),
(1, 'F', 6, 'NORMAL'), (1, 'F', 7, 'NORMAL'), (1, 'F', 8, 'NORMAL'), (1, 'F', 9, 'NORMAL'), (1, 'F', 10, 'NORMAL'),
(1, 'F', 11, 'NORMAL'), (1, 'F', 12, 'NORMAL'), (1, 'F', 13, 'NORMAL'), (1, 'F', 14, 'NORMAL'), (1, 'F', 15, 'NORMAL'),
(1, 'F', 16, 'NORMAL'), (1, 'F', 17, 'NORMAL'), (1, 'F', 18, 'NORMAL'), (1, 'F', 19, 'NORMAL'), (1, 'F', 20, 'NORMAL'),
(1, 'G', 1, 'NORMAL'), (1, 'G', 2, 'NORMAL'), (1, 'G', 3, 'NORMAL'), (1, 'G', 4, 'NORMAL'), (1, 'G', 5, 'NORMAL'),
(1, 'G', 6, 'NORMAL'), (1, 'G', 7, 'NORMAL'), (1, 'G', 8, 'NORMAL'), (1, 'G', 9, 'NORMAL'), (1, 'G', 10, 'NORMAL'),
(1, 'G', 11, 'NORMAL'), (1, 'G', 12, 'NORMAL'), (1, 'G', 13, 'NORMAL'), (1, 'G', 14, 'NORMAL'), (1, 'G', 15, 'NORMAL'),
(1, 'G', 16, 'NORMAL'), (1, 'G', 17, 'NORMAL'), (1, 'G', 18, 'NORMAL'), (1, 'G', 19, 'NORMAL'), (1, 'G', 20, 'NORMAL'),
(1, 'H', 1, 'NORMAL'), (1, 'H', 2, 'NORMAL'), (1, 'H', 3, 'NORMAL'), (1, 'H', 4, 'NORMAL'), (1, 'H', 5, 'NORMAL'),
(1, 'H', 6, 'NORMAL'), (1, 'H', 7, 'NORMAL'), (1, 'H', 8, 'NORMAL'), (1, 'H', 9, 'NORMAL'), (1, 'H', 10, 'NORMAL'),
(1, 'H', 11, 'NORMAL'), (1, 'H', 12, 'NORMAL'), (1, 'H', 13, 'NORMAL'), (1, 'H', 14, 'NORMAL'), (1, 'H', 15, 'NORMAL'),
(1, 'H', 16, 'NORMAL'), (1, 'H', 17, 'NORMAL'), (1, 'H', 18, 'NORMAL'), (1, 'H', 19, 'NORMAL'), (1, 'H', 20, 'NORMAL'),
(1, 'I', 1, 'NORMAL'), (1, 'I', 2, 'NORMAL'), (1, 'I', 3, 'NORMAL'), (1, 'I', 4, 'NORMAL'), (1, 'I', 5, 'NORMAL'),
(1, 'I', 6, 'NORMAL'), (1, 'I', 7, 'NORMAL'), (1, 'I', 8, 'NORMAL'), (1, 'I', 9, 'NORMAL'), (1, 'I', 10, 'NORMAL'),
(1, 'I', 11, 'NORMAL'), (1, 'I', 12, 'NORMAL'), (1, 'I', 13, 'NORMAL'), (1, 'I', 14, 'NORMAL'), (1, 'I', 15, 'NORMAL'),
(1, 'I', 16, 'NORMAL'), (1, 'I', 17, 'NORMAL'), (1, 'I', 18, 'NORMAL'), (1, 'I', 19, 'NORMAL'), (1, 'I', 20, 'NORMAL'),
(1, 'J', 1, 'NORMAL'), (1, 'J', 2, 'NORMAL'), (1, 'J', 3, 'NORMAL'), (1, 'J', 4, 'NORMAL'), (1, 'J', 5, 'NORMAL'),
(1, 'J', 6, 'NORMAL'), (1, 'J', 7, 'NORMAL'), (1, 'J', 8, 'NORMAL'), (1, 'J', 9, 'NORMAL'), (1, 'J', 10, 'NORMAL'),
(1, 'J', 11, 'NORMAL'), (1, 'J', 12, 'NORMAL'), (1, 'J', 13, 'NORMAL'), (1, 'J', 14, 'NORMAL'), (1, 'J', 15, 'NORMAL'),
(1, 'J', 16, 'NORMAL'), (1, 'J', 17, 'NORMAL'), (1, 'J', 18, 'NORMAL'), (1, 'J', 19, 'NORMAL'), (1, 'J', 20, 'NORMAL'),
(1, 'K', 1, 'NORMAL'), (1, 'K', 2, 'NORMAL'), (1, 'K', 3, 'NORMAL'), (1, 'K', 4, 'NORMAL'), (1, 'K', 5, 'NORMAL'),
(1, 'K', 6, 'NORMAL'), (1, 'K', 7, 'NORMAL'), (1, 'K', 8, 'NORMAL'), (1, 'K', 9, 'NORMAL'), (1, 'K', 10, 'NORMAL'),
(1, 'K', 11, 'NORMAL'), (1, 'K', 12, 'NORMAL'), (1, 'K', 13, 'NORMAL'), (1, 'K', 14, 'NORMAL'), (1, 'K', 15, 'NORMAL'),
(1, 'K', 16, 'NORMAL'), (1, 'K', 17, 'NORMAL'), (1, 'K', 18, 'NORMAL'), (1, 'K', 19, 'NORMAL'), (1, 'K', 20, 'NORMAL'),
(1, 'L', 1, 'NORMAL'), (1, 'L', 2, 'NORMAL'), (1, 'L', 3, 'NORMAL'), (1, 'L', 4, 'NORMAL'), (1, 'L', 5, 'NORMAL'),
(1, 'L', 6, 'NORMAL'), (1, 'L', 7, 'NORMAL'), (1, 'L', 8, 'NORMAL'), (1, 'L', 9, 'NORMAL'), (1, 'L', 10, 'NORMAL'),
(1, 'L', 11, 'NORMAL'), (1, 'L', 12, 'NORMAL'), (1, 'L', 13, 'NORMAL'), (1, 'L', 14, 'NORMAL'), (1, 'L', 15, 'NORMAL'),
(1, 'L', 16, 'NORMAL'), (1, 'L', 17, 'NORMAL'), (1, 'L', 18, 'NORMAL'), (1, 'L', 19, 'NORMAL'), (1, 'L', 20, 'NORMAL'),
(1, 'M', 1, 'NORMAL'), (1, 'M', 2, 'NORMAL'), (1, 'M', 3, 'NORMAL'), (1, 'M', 4, 'NORMAL'), (1, 'M', 5, 'NORMAL'),
(1, 'M', 6, 'NORMAL'), (1, 'M', 7, 'NORMAL'), (1, 'M', 8, 'NORMAL'), (1, 'M', 9, 'NORMAL'), (1, 'M', 10, 'NORMAL'),
(1, 'M', 11, 'NORMAL'), (1, 'M', 12, 'NORMAL'), (1, 'M', 13, 'NORMAL'), (1, 'M', 14, 'NORMAL'), (1, 'M', 15, 'NORMAL'),
(1, 'M', 16, 'NORMAL'), (1, 'M', 17, 'NORMAL'), (1, 'M', 18, 'NORMAL'), (1, 'M', 19, 'NORMAL'), (1, 'M', 20, 'NORMAL'),
(1, 'N', 1, 'NORMAL'), (1, 'N', 2, 'NORMAL'), (1, 'N', 3, 'NORMAL'), (1, 'N', 4, 'NORMAL'), (1, 'N', 5, 'NORMAL'),
(1, 'N', 6, 'NORMAL'), (1, 'N', 7, 'NORMAL'), (1, 'N', 8, 'NORMAL'), (1, 'N', 9, 'NORMAL'), (1, 'N', 10, 'NORMAL'),
(1, 'N', 11, 'NORMAL'), (1, 'N', 12, 'NORMAL'), (1, 'N', 13, 'NORMAL'), (1, 'N', 14, 'NORMAL'), (1, 'N', 15, 'NORMAL'),
(1, 'N', 16, 'NORMAL'), (1, 'N', 17, 'NORMAL'), (1, 'N', 18, 'NORMAL'), (1, 'N', 19, 'NORMAL'), (1, 'N', 20, 'NORMAL'),
(1, 'O', 1, 'NORMAL'), (1, 'O', 2, 'NORMAL'), (1, 'O', 3, 'NORMAL'), (1, 'O', 4, 'NORMAL'), (1, 'O', 5, 'NORMAL'),
(1, 'O', 6, 'NORMAL'), (1, 'O', 7, 'NORMAL'), (1, 'O', 8, 'NORMAL'), (1, 'O', 9, 'NORMAL'), (1, 'O', 10, 'NORMAL'),
(1, 'O', 11, 'NORMAL'), (1, 'O', 12, 'NORMAL'), (1, 'O', 13, 'NORMAL'), (1, 'O', 14, 'NORMAL'), (1, 'O', 15, 'NORMAL'),
(1, 'O', 16, 'NORMAL'), (1, 'O', 17, 'NORMAL'), (1, 'O', 18, 'NORMAL'), (1, 'O', 19, 'NORMAL'), (1, 'O', 20, 'NORMAL');

-- Phòng 2: Standard 1 - 10 hàng (A-J) x 20 ghế = 200 ghế
-- Hàng A là VIP

-- Hàng A (VIP) - 20 ghế
INSERT INTO seats (room_id, row_number, seat_number, seat_type) VALUES
(2, 'A', 1, 'VIP'), (2, 'A', 2, 'VIP'), (2, 'A', 3, 'VIP'), (2, 'A', 4, 'VIP'), (2, 'A', 5, 'VIP'),
(2, 'A', 6, 'VIP'), (2, 'A', 7, 'VIP'), (2, 'A', 8, 'VIP'), (2, 'A', 9, 'VIP'), (2, 'A', 10, 'VIP'),
(2, 'A', 11, 'VIP'), (2, 'A', 12, 'VIP'), (2, 'A', 13, 'VIP'), (2, 'A', 14, 'VIP'), (2, 'A', 15, 'VIP'),
(2, 'A', 16, 'VIP'), (2, 'A', 17, 'VIP'), (2, 'A', 18, 'VIP'), (2, 'A', 19, 'VIP'), (2, 'A', 20, 'VIP');

-- Hàng B-J (NORMAL) - 9 hàng x 20 ghế = 180 ghế
INSERT INTO seats (room_id, row_number, seat_number, seat_type) VALUES
(2, 'B', 1, 'NORMAL'), (2, 'B', 2, 'NORMAL'), (2, 'B', 3, 'NORMAL'), (2, 'B', 4, 'NORMAL'), (2, 'B', 5, 'NORMAL'),
(2, 'B', 6, 'NORMAL'), (2, 'B', 7, 'NORMAL'), (2, 'B', 8, 'NORMAL'), (2, 'B', 9, 'NORMAL'), (2, 'B', 10, 'NORMAL'),
(2, 'B', 11, 'NORMAL'), (2, 'B', 12, 'NORMAL'), (2, 'B', 13, 'NORMAL'), (2, 'B', 14, 'NORMAL'), (2, 'B', 15, 'NORMAL'),
(2, 'B', 16, 'NORMAL'), (2, 'B', 17, 'NORMAL'), (2, 'B', 18, 'NORMAL'), (2, 'B', 19, 'NORMAL'), (2, 'B', 20, 'NORMAL'),
(2, 'C', 1, 'NORMAL'), (2, 'C', 2, 'NORMAL'), (2, 'C', 3, 'NORMAL'), (2, 'C', 4, 'NORMAL'), (2, 'C', 5, 'NORMAL'),
(2, 'C', 6, 'NORMAL'), (2, 'C', 7, 'NORMAL'), (2, 'C', 8, 'NORMAL'), (2, 'C', 9, 'NORMAL'), (2, 'C', 10, 'NORMAL'),
(2, 'C', 11, 'NORMAL'), (2, 'C', 12, 'NORMAL'), (2, 'C', 13, 'NORMAL'), (2, 'C', 14, 'NORMAL'), (2, 'C', 15, 'NORMAL'),
(2, 'C', 16, 'NORMAL'), (2, 'C', 17, 'NORMAL'), (2, 'C', 18, 'NORMAL'), (2, 'C', 19, 'NORMAL'), (2, 'C', 20, 'NORMAL'),
(2, 'D', 1, 'NORMAL'), (2, 'D', 2, 'NORMAL'), (2, 'D', 3, 'NORMAL'), (2, 'D', 4, 'NORMAL'), (2, 'D', 5, 'NORMAL'),
(2, 'D', 6, 'NORMAL'), (2, 'D', 7, 'NORMAL'), (2, 'D', 8, 'NORMAL'), (2, 'D', 9, 'NORMAL'), (2, 'D', 10, 'NORMAL'),
(2, 'D', 11, 'NORMAL'), (2, 'D', 12, 'NORMAL'), (2, 'D', 13, 'NORMAL'), (2, 'D', 14, 'NORMAL'), (2, 'D', 15, 'NORMAL'),
(2, 'D', 16, 'NORMAL'), (2, 'D', 17, 'NORMAL'), (2, 'D', 18, 'NORMAL'), (2, 'D', 19, 'NORMAL'), (2, 'D', 20, 'NORMAL'),
(2, 'E', 1, 'NORMAL'), (2, 'E', 2, 'NORMAL'), (2, 'E', 3, 'NORMAL'), (2, 'E', 4, 'NORMAL'), (2, 'E', 5, 'NORMAL'),
(2, 'E', 6, 'NORMAL'), (2, 'E', 7, 'NORMAL'), (2, 'E', 8, 'NORMAL'), (2, 'E', 9, 'NORMAL'), (2, 'E', 10, 'NORMAL'),
(2, 'E', 11, 'NORMAL'), (2, 'E', 12, 'NORMAL'), (2, 'E', 13, 'NORMAL'), (2, 'E', 14, 'NORMAL'), (2, 'E', 15, 'NORMAL'),
(2, 'E', 16, 'NORMAL'), (2, 'E', 17, 'NORMAL'), (2, 'E', 18, 'NORMAL'), (2, 'E', 19, 'NORMAL'), (2, 'E', 20, 'NORMAL'),
(2, 'F', 1, 'NORMAL'), (2, 'F', 2, 'NORMAL'), (2, 'F', 3, 'NORMAL'), (2, 'F', 4, 'NORMAL'), (2, 'F', 5, 'NORMAL'),
(2, 'F', 6, 'NORMAL'), (2, 'F', 7, 'NORMAL'), (2, 'F', 8, 'NORMAL'), (2, 'F', 9, 'NORMAL'), (2, 'F', 10, 'NORMAL'),
(2, 'F', 11, 'NORMAL'), (2, 'F', 12, 'NORMAL'), (2, 'F', 13, 'NORMAL'), (2, 'F', 14, 'NORMAL'), (2, 'F', 15, 'NORMAL'),
(2, 'F', 16, 'NORMAL'), (2, 'F', 17, 'NORMAL'), (2, 'F', 18, 'NORMAL'), (2, 'F', 19, 'NORMAL'), (2, 'F', 20, 'NORMAL'),
(2, 'G', 1, 'NORMAL'), (2, 'G', 2, 'NORMAL'), (2, 'G', 3, 'NORMAL'), (2, 'G', 4, 'NORMAL'), (2, 'G', 5, 'NORMAL'),
(2, 'G', 6, 'NORMAL'), (2, 'G', 7, 'NORMAL'), (2, 'G', 8, 'NORMAL'), (2, 'G', 9, 'NORMAL'), (2, 'G', 10, 'NORMAL'),
(2, 'G', 11, 'NORMAL'), (2, 'G', 12, 'NORMAL'), (2, 'G', 13, 'NORMAL'), (2, 'G', 14, 'NORMAL'), (2, 'G', 15, 'NORMAL'),
(2, 'G', 16, 'NORMAL'), (2, 'G', 17, 'NORMAL'), (2, 'G', 18, 'NORMAL'), (2, 'G', 19, 'NORMAL'), (2, 'G', 20, 'NORMAL'),
(2, 'H', 1, 'NORMAL'), (2, 'H', 2, 'NORMAL'), (2, 'H', 3, 'NORMAL'), (2, 'H', 4, 'NORMAL'), (2, 'H', 5, 'NORMAL'),
(2, 'H', 6, 'NORMAL'), (2, 'H', 7, 'NORMAL'), (2, 'H', 8, 'NORMAL'), (2, 'H', 9, 'NORMAL'), (2, 'H', 10, 'NORMAL'),
(2, 'H', 11, 'NORMAL'), (2, 'H', 12, 'NORMAL'), (2, 'H', 13, 'NORMAL'), (2, 'H', 14, 'NORMAL'), (2, 'H', 15, 'NORMAL'),
(2, 'H', 16, 'NORMAL'), (2, 'H', 17, 'NORMAL'), (2, 'H', 18, 'NORMAL'), (2, 'H', 19, 'NORMAL'), (2, 'H', 20, 'NORMAL'),
(2, 'I', 1, 'NORMAL'), (2, 'I', 2, 'NORMAL'), (2, 'I', 3, 'NORMAL'), (2, 'I', 4, 'NORMAL'), (2, 'I', 5, 'NORMAL'),
(2, 'I', 6, 'NORMAL'), (2, 'I', 7, 'NORMAL'), (2, 'I', 8, 'NORMAL'), (2, 'I', 9, 'NORMAL'), (2, 'I', 10, 'NORMAL'),
(2, 'I', 11, 'NORMAL'), (2, 'I', 12, 'NORMAL'), (2, 'I', 13, 'NORMAL'), (2, 'I', 14, 'NORMAL'), (2, 'I', 15, 'NORMAL'),
(2, 'I', 16, 'NORMAL'), (2, 'I', 17, 'NORMAL'), (2, 'I', 18, 'NORMAL'), (2, 'I', 19, 'NORMAL'), (2, 'I', 20, 'NORMAL'),
(2, 'J', 1, 'NORMAL'), (2, 'J', 2, 'NORMAL'), (2, 'J', 3, 'NORMAL'), (2, 'J', 4, 'NORMAL'), (2, 'J', 5, 'NORMAL'),
(2, 'J', 6, 'NORMAL'), (2, 'J', 7, 'NORMAL'), (2, 'J', 8, 'NORMAL'), (2, 'J', 9, 'NORMAL'), (2, 'J', 10, 'NORMAL'),
(2, 'J', 11, 'NORMAL'), (2, 'J', 12, 'NORMAL'), (2, 'J', 13, 'NORMAL'), (2, 'J', 14, 'NORMAL'), (2, 'J', 15, 'NORMAL'),
(2, 'J', 16, 'NORMAL'), (2, 'J', 17, 'NORMAL'), (2, 'J', 18, 'NORMAL'), (2, 'J', 19, 'NORMAL'), (2, 'J', 20, 'NORMAL');

-- Phòng 3: Lotte 1 - 12 hàng (A-L) x 21 ghế = 252 ghế
-- Hàng A, B, C là VIP

-- Tạo ghế cho phòng 3 bằng stored procedure approach (dùng script bash sẽ nhanh hơn)
-- Tạm thời tạo bằng cách đơn giản: sử dụng script bash create-seats-working.sh

-- Phòng 4: Starium 1 - 18 hàng (A-R) x 20 ghế = 360 ghế  
-- Hàng A, B, C là VIP

-- Tạo ghế cho phòng 4 bằng stored procedure approach
-- Tạm thời tạo bằng cách đơn giản: sử dụng script bash create-seats-working.sh



