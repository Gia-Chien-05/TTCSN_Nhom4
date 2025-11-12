#!/bin/bash

# Script tạo ghế bằng cách generate SQL và chạy
echo "=== Tạo Ghế cho Tất Cả Phòng Chiếu ==="
echo ""

DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

# Tạo file SQL tạm
TEMP_SQL="/tmp/create_seats_$$.sql"

echo "Đang tạo file SQL..."
cat > "$TEMP_SQL" <<'EOFSQL'
-- Tạo ghế cho Phòng 1: IMAX 1 (15 hàng x 20 ghế)
EOFSQL

# Tạo ghế cho phòng 1
for row in A B C D E F G H I J K L M N O; do
    seat_type="NORMAL"
    if [[ "$row" == "A" || "$row" == "B" ]]; then
        seat_type="VIP"
    fi
    
    echo "-- Hàng $row" >> "$TEMP_SQL"
    values=""
    for seat in {1..20}; do
        if [ -n "$values" ]; then
            values="$values, "
        fi
        values="$values(1, '$row', $seat, '$seat_type', NOW(), NOW())"
    done
    echo "INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at) VALUES $values;" >> "$TEMP_SQL"
done

# Tạo ghế cho phòng 2: Standard 1 (10 hàng x 20 ghế)
cat >> "$TEMP_SQL" <<'EOFSQL'

-- Tạo ghế cho Phòng 2: Standard 1 (10 hàng x 20 ghế)
EOFSQL

for row in A B C D E F G H I J; do
    seat_type="NORMAL"
    if [[ "$row" == "A" ]]; then
        seat_type="VIP"
    fi
    
    echo "-- Hàng $row" >> "$TEMP_SQL"
    values=""
    for seat in {1..20}; do
        if [ -n "$values" ]; then
            values="$values, "
        fi
        values="$values(2, '$row', $seat, '$seat_type', NOW(), NOW())"
    done
    echo "INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at) VALUES $values;" >> "$TEMP_SQL"
done

# Tạo ghế cho phòng 3: Lotte 1 (12 hàng x 21 ghế)
cat >> "$TEMP_SQL" <<'EOFSQL'

-- Tạo ghế cho Phòng 3: Lotte 1 (12 hàng x 21 ghế)
EOFSQL

for row in A B C D E F G H I J K L; do
    seat_type="NORMAL"
    if [[ "$row" == "A" || "$row" == "B" || "$row" == "C" ]]; then
        seat_type="VIP"
    fi
    
    echo "-- Hàng $row" >> "$TEMP_SQL"
    values=""
    for seat in {1..21}; do
        if [ -n "$values" ]; then
            values="$values, "
        fi
        values="$values(3, '$row', $seat, '$seat_type', NOW(), NOW())"
    done
    echo "INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at) VALUES $values;" >> "$TEMP_SQL"
done

# Tạo ghế cho phòng 4: Starium 1 (18 hàng x 20 ghế)
cat >> "$TEMP_SQL" <<'EOFSQL'

-- Tạo ghế cho Phòng 4: Starium 1 (18 hàng x 20 ghế)
EOFSQL

for row in A B C D E F G H I J K L M N O P Q R; do
    seat_type="NORMAL"
    if [[ "$row" == "A" || "$row" == "B" || "$row" == "C" ]]; then
        seat_type="VIP"
    fi
    
    echo "-- Hàng $row" >> "$TEMP_SQL"
    values=""
    for seat in {1..20}; do
        if [ -n "$values" ]; then
            values="$values, "
        fi
        values="$values(4, '$row', $seat, '$seat_type', NOW(), NOW())"
    done
    echo "INSERT INTO seats (room_id, row_number, seat_number, seat_type, created_at, updated_at) VALUES $values;" >> "$TEMP_SQL"
done

echo "Đang chạy SQL..."
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" < "$TEMP_SQL" 2>&1 | grep -v "Duplicate entry" || true

# Kiểm tra kết quả
echo ""
echo "=== Kiểm tra kết quả ==="
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
SELECT id, row_number, seat_number, seat_type 
FROM seats 
WHERE room_id = 1 
ORDER BY row_number, seat_number 
LIMIT 30;
"

# Xóa file tạm
rm -f "$TEMP_SQL"

echo ""
echo "🎉 Hoàn tất!"



