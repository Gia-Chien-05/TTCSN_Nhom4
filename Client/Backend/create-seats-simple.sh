#!/bin/bash

# Script đơn giản để tạo ghế cho phòng chiếu
echo "=== Tạo Ghế cho Phòng Chiếu ==="
echo ""

DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

echo "Đang tạo ghế cho tất cả phòng chiếu..."
echo ""

mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" <<'EOF'
-- Xóa ghế cũ nếu có (tùy chọn)
-- DELETE FROM seats;

-- Tạo ghế cho từng phòng
-- Phòng 1: IMAX 1 (CGV Vincom Center) - 300 ghế
-- Giả sử: 15 hàng x 20 ghế/hàng, hàng A-B là VIP

INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at)
SELECT 
    1 as room_id,
    CHAR(65 + row_num) as row_number,  -- A, B, C, ...
    seat_num as seat_number,
    CASE 
        WHEN CHAR(65 + row_num) IN ('A', 'B') THEN 'VIP'
        ELSE 'NORMAL'
    END as seat_type,
    NOW() as created_at,
    NOW() as updated_at
FROM (
    SELECT 
        row_num,
        seat_num
    FROM (
        SELECT 0 as row_num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
        SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION 
        SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14
    ) rows
    CROSS JOIN (
        SELECT 1 as seat_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
        SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION
        SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
        SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
    ) seats
) combinations
WHERE NOT EXISTS (
    SELECT 1 FROM seats s 
    WHERE s.room_id = 1 
    AND s.row_number = CHAR(65 + row_num)
    AND s.seat_number = seat_num
);

-- Phòng 2: Standard 1 (CGV Vincom Center) - 200 ghế
-- 10 hàng x 20 ghế/hàng, hàng A là VIP
INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at)
SELECT 
    2 as room_id,
    CHAR(65 + row_num) as row_number,
    seat_num as seat_number,
    CASE 
        WHEN CHAR(65 + row_num) = 'A' THEN 'VIP'
        ELSE 'NORMAL'
    END as seat_type,
    NOW() as created_at,
    NOW() as updated_at
FROM (
    SELECT 
        row_num,
        seat_num
    FROM (
        SELECT 0 as row_num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
        SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
    ) rows
    CROSS JOIN (
        SELECT 1 as seat_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
        SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION
        SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
        SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
    ) seats
) combinations
WHERE NOT EXISTS (
    SELECT 1 FROM seats s 
    WHERE s.room_id = 2 
    AND s.row_number = CHAR(65 + row_num)
    AND s.seat_number = seat_num
);

-- Phòng 3: Lotte 1 (Lotte Cinema Đà Nẵng) - 250 ghế
-- 10 hàng x 25 ghế/hàng, hàng A-B là VIP
INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at)
SELECT 
    3 as room_id,
    CHAR(65 + row_num) as row_number,
    seat_num as seat_number,
    CASE 
        WHEN CHAR(65 + row_num) IN ('A', 'B') THEN 'VIP'
        ELSE 'NORMAL'
    END as seat_type,
    NOW() as created_at,
    NOW() as updated_at
FROM (
    SELECT 
        row_num,
        seat_num
    FROM (
        SELECT 0 as row_num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
        SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
    ) rows
    CROSS JOIN (
        SELECT 1 as seat_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
        SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION
        SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
        SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
        SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25
    ) seats
) combinations
WHERE NOT EXISTS (
    SELECT 1 FROM seats s 
    WHERE s.room_id = 3 
    AND s.row_number = CHAR(65 + row_num)
    AND s.seat_number = seat_num
);

-- Phòng 4: Starium 1 (BHD Star Cineplex) - 350 ghế
-- 14 hàng x 25 ghế/hàng, hàng A-C là VIP
INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at)
SELECT 
    4 as room_id,
    CHAR(65 + row_num) as row_number,
    seat_num as seat_number,
    CASE 
        WHEN CHAR(65 + row_num) IN ('A', 'B', 'C') THEN 'VIP'
        ELSE 'NORMAL'
    END as seat_type,
    NOW() as created_at,
    NOW() as updated_at
FROM (
    SELECT 
        row_num,
        seat_num
    FROM (
        SELECT 0 as row_num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
        SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION
        SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13
    ) rows
    CROSS JOIN (
        SELECT 1 as seat_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
        SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION
        SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
        SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
        SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25
    ) seats
) combinations
WHERE NOT EXISTS (
    SELECT 1 FROM seats s 
    WHERE s.room_id = 4 
    AND s.row_number = CHAR(65 + row_num)
    AND s.seat_number = seat_num
);

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
GROUP BY r.id, r.room_name, r.capacity
ORDER BY r.id;
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Đã tạo ghế thành công!"
    echo ""
    echo "=== Thống kê ghế ==="
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT 
        r.room_name,
        c.name as cinema_name,
        COUNT(s.id) as total_seats,
        COUNT(CASE WHEN s.seat_type = 'VIP' THEN 1 END) as vip_seats,
        COUNT(CASE WHEN s.seat_type = 'NORMAL' THEN 1 END) as normal_seats,
        MIN(s.row_number) as first_row,
        MAX(s.row_number) as last_row
    FROM cinema_rooms r
    JOIN cinemas c ON r.cinema_id = c.id
    LEFT JOIN seats s ON r.id = s.room_id
    GROUP BY r.id, r.room_name, c.name
    ORDER BY r.id;
    "
    echo ""
    echo "=== Ví dụ ghế đã tạo (Phòng 1) ==="
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT id, row_number, seat_number, seat_type 
    FROM seats 
    WHERE room_id = 1 
    ORDER BY row_number, seat_number 
    LIMIT 20;
    "
    echo ""
    echo "🎉 Hoàn tất! Bây giờ bạn có thể chọn ghế khi đặt vé."
else
    echo ""
    echo "❌ Có lỗi xảy ra khi tạo ghế."
fi



