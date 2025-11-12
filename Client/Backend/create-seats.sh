#!/bin/bash

# Script để tạo ghế cho tất cả phòng chiếu
echo "=== Tạo Ghế cho Phòng Chiếu ==="
echo ""

DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

echo "Đang tạo ghế cho tất cả phòng chiếu..."
echo ""

mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" <<'EOF'
-- Tạo ghế cho từng phòng chiếu
-- Dựa trên thông tin capacity, total_rows, seats_per_row từ cinema_rooms

-- Lấy thông tin phòng chiếu
SET @room_id = 0;
SET @cinema_id = 0;
SET @room_name = '';
SET @total_rows = 0;
SET @seats_per_row = 0;
SET @vip_rows = '';

-- Cursor để duyệt qua từng phòng
DROP PROCEDURE IF EXISTS CreateSeatsForAllRooms;

DELIMITER //

CREATE PROCEDURE CreateSeatsForAllRooms()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_room_id BIGINT;
    DECLARE v_total_rows INT;
    DECLARE v_seats_per_row INT;
    DECLARE v_vip_rows VARCHAR(100);
    DECLARE v_row_num INT;
    DECLARE v_seat_num INT;
    DECLARE v_row_letter CHAR(1);
    DECLARE v_seat_type VARCHAR(20);
    DECLARE cur_rooms CURSOR FOR 
        SELECT id, total_rows, seats_per_row, COALESCE(vip_rows, 'A,B') as vip_rows
        FROM cinema_rooms;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_rooms;
    
    room_loop: LOOP
        FETCH cur_rooms INTO v_room_id, v_total_rows, v_seats_per_row, v_vip_rows;
        IF done THEN
            LEAVE room_loop;
        END IF;

        -- Tạo ghế cho từng hàng
        SET v_row_num = 0;
        WHILE v_row_num < v_total_rows DO
            -- Convert row number to letter (A, B, C, ...)
            SET v_row_letter = CHAR(65 + v_row_num); -- 65 is ASCII for 'A'
            
            -- Kiểm tra xem hàng này có phải VIP không
            IF FIND_IN_SET(v_row_letter, v_vip_rows) > 0 THEN
                SET v_seat_type = 'VIP';
            ELSE
                SET v_seat_type = 'NORMAL';
            END IF;

            -- Tạo ghế cho từng cột trong hàng
            SET v_seat_num = 1;
            WHILE v_seat_num <= v_seats_per_row DO
                -- Kiểm tra xem ghế đã tồn tại chưa
                IF NOT EXISTS (
                    SELECT 1 FROM seats 
                    WHERE room_id = v_room_id 
                    AND row_number = v_row_letter 
                    AND seat_number = v_seat_num
                ) THEN
                    INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at)
                    VALUES (v_room_id, v_row_letter, v_seat_num, v_seat_type, NOW(), NOW());
                END IF;
                
                SET v_seat_num = v_seat_num + 1;
            END WHILE;
            
            SET v_row_num = v_row_num + 1;
        END WHILE;

    END LOOP;
    
    CLOSE cur_rooms;
END//

DELIMITER ;

-- Chạy stored procedure
CALL CreateSeatsForAllRooms();

-- Xóa stored procedure
DROP PROCEDURE IF EXISTS CreateSeatsForAllRooms;

-- Kiểm tra kết quả
SELECT 
    r.id as room_id,
    r.room_name,
    r.capacity,
    COUNT(s.id) as seats_created,
    COUNT(CASE WHEN s.seat_type = 'VIP' THEN 1 END) as vip_seats,
    COUNT(CASE WHEN s.seat_type = 'NORMAL' THEN 1 END) as normal_seats
FROM cinema_rooms r
LEFT JOIN seats s ON r.id = s.room_id
GROUP BY r.id, r.room_name, r.capacity;
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Đã tạo ghế thành công!"
    echo ""
    echo "=== Kiểm tra ghế đã tạo ==="
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT 
        r.room_name,
        COUNT(s.id) as total_seats,
        MIN(s.row_number) as first_row,
        MAX(s.row_number) as last_row,
        MIN(s.seat_number) as first_seat,
        MAX(s.seat_number) as last_seat
    FROM cinema_rooms r
    JOIN seats s ON r.id = s.room_id
    GROUP BY r.id, r.room_name;
    "
    echo ""
    echo "🎉 Hoàn tất! Bây giờ bạn có thể chọn ghế khi đặt vé."
else
    echo ""
    echo "❌ Có lỗi xảy ra khi tạo ghế."
fi



