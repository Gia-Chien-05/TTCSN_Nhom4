#!/bin/bash

echo "=== Kiểm tra dữ liệu Seats ==="
echo ""

DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

echo "1. Kiểm tra database connection..."
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} -e "USE $DB_NAME; SELECT 'Database connected' as status;" 2>&1

echo ""
echo "2. Tổng số ghế trong bảng seats:"
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "SELECT COUNT(*) as total_seats FROM seats;" 2>&1

echo ""
echo "3. Phân bổ ghế theo phòng:"
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
SELECT 
    r.id as room_id,
    r.room_name,
    COUNT(s.id) as total_seats,
    COUNT(CASE WHEN s.seat_type = 'VIP' THEN 1 END) as vip_seats,
    COUNT(CASE WHEN s.seat_type = 'NORMAL' THEN 1 END) as normal_seats
FROM cinema_rooms r
LEFT JOIN seats s ON r.id = s.room_id
GROUP BY r.id, r.room_name
ORDER BY r.id;
" 2>&1

echo ""
echo "4. 10 ghế đầu tiên:"
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
SELECT id, room_id, \`row_number\`, seat_number, seat_type
FROM seats
ORDER BY id
LIMIT 10;
" 2>&1

echo ""
echo "5. Kiểm tra các hàng trong phòng 1:"
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
SELECT 
    \`row_number\`,
    COUNT(*) as seats_count,
    seat_type
FROM seats
WHERE room_id = 1
GROUP BY \`row_number\`, seat_type
ORDER BY \`row_number\`;
" 2>&1

echo ""
echo "✅ Kiểm tra hoàn tất!"



