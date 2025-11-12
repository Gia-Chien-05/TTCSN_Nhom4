#!/bin/bash

# Script tạo ghế - không dùng created_at, updated_at
echo "=== Tạo Ghế cho Phòng Chiếu ==="
echo ""

DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

create_seats_for_room() {
    local room_id=$1
    local rows=$2
    local seats_per_row=$3
    local vip_rows=$4
    
    echo "Đang tạo ghế cho Phòng $room_id..."
    
    for row_char in $rows; do
        # Xác định loại ghế
        local seat_type="NORMAL"
        if echo "$vip_rows" | grep -q "$row_char"; then
            seat_type="VIP"
        fi
        
        # Tạo INSERT statement cho hàng này (tối đa 1000 ghế mỗi lần)
        local values=""
        local count=0
        for seat in $(seq 1 $seats_per_row); do
            if [ -n "$values" ]; then
                values="$values, "
            fi
            values="$values($room_id, '$row_char', $seat, '$seat_type')"
            count=$((count + 1))
        done
        
        # Chạy INSERT, bỏ qua lỗi duplicate
        mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
            INSERT IGNORE INTO seats (room_id, \`row_number\`, seat_number, seat_type)
            VALUES $values;
        " 2>&1 | grep -v "Duplicate entry" || true
    done
}

# Phòng 1: IMAX 1 - 15 hàng x 20 ghế, hàng A-B VIP
create_seats_for_room 1 "A B C D E F G H I J K L M N O" 20 "A B"

# Phòng 2: Standard 1 - 10 hàng x 20 ghế, hàng A VIP
create_seats_for_room 2 "A B C D E F G H I J" 20 "A"

# Phòng 3: Lotte 1 - 12 hàng x 21 ghế, hàng A-B-C VIP
create_seats_for_room 3 "A B C D E F G H I J K L" 21 "A B C"

# Phòng 4: Starium 1 - 18 hàng x 20 ghế, hàng A-B-C VIP
create_seats_for_room 4 "A B C D E F G H I J K L M N O P Q R" 20 "A B C"

# Kiểm tra kết quả
echo ""
echo "=== Kết quả ==="
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" <<EOF
SELECT 
    r.id as room_id,
    r.room_name,
    c.name as cinema_name,
    COUNT(s.id) as total_seats,
    COUNT(CASE WHEN s.seat_type = 'VIP' THEN 1 END) as vip_seats,
    COUNT(CASE WHEN s.seat_type = 'NORMAL' THEN 1 END) as normal_seats
FROM cinema_rooms r
JOIN cinemas c ON r.cinema_id = c.id
LEFT JOIN seats s ON r.id = s.room_id
GROUP BY r.id, r.room_name, c.name
ORDER BY r.id;
EOF

echo ""
echo "=== Ví dụ ghế (Phòng 1) ==="
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
SELECT id, \`row_number\`, seat_number, seat_type 
FROM seats 
WHERE room_id = 1 
ORDER BY \`row_number\`, seat_number 
LIMIT 30;
"

echo ""
echo "✅ Hoàn tất! Bây giờ bạn có thể chọn ghế khi đặt vé."



