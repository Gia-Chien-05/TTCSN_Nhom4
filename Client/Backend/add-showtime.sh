#!/bin/bash

# Script để thêm suất chiếu vào database
# Sử dụng: ./add-showtime.sh

echo "=== Script Thêm Suất Chiếu ==="
echo ""

# Đọc thông tin database từ application.properties
DB_USER=$(grep "spring.datasource.username" src/main/resources/application.properties | cut -d'=' -f2)
DB_PASS=$(grep "spring.datasource.password" src/main/resources/application.properties | cut -d'=' -f2)
DB_NAME=$(grep "spring.datasource.url" src/main/resources/application.properties | sed -n 's/.*\/\([^?]*\).*/\1/p')

if [ -z "$DB_USER" ] || [ -z "$DB_NAME" ]; then
    echo "Không thể đọc thông tin database từ application.properties"
    echo "Vui lòng nhập thông tin thủ công:"
    read -p "Database User: " DB_USER
    read -sp "Database Password: " DB_PASS
    echo ""
    read -p "Database Name: " DB_NAME
fi

echo "Đang kết nối đến database: $DB_NAME"
echo ""

# Kiểm tra dữ liệu hiện có
echo "=== Kiểm tra dữ liệu hiện có ==="
echo ""

echo "1. Danh sách phim:"
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SELECT id, title_vietnamese as title FROM movies LIMIT 5;" 2>/dev/null || {
    echo "Lỗi kết nối database. Vui lòng kiểm tra lại thông tin."
    exit 1
}

echo ""
echo "2. Danh sách rạp:"
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SELECT id, name, city FROM cinemas LIMIT 5;"

echo ""
echo "3. Danh sách phòng chiếu:"
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SELECT r.id, r.room_name, r.capacity, c.name as cinema_name FROM cinema_rooms r JOIN cinemas c ON r.cinema_id = c.id LIMIT 5;"

echo ""
read -p "Nhấn Enter để tiếp tục thêm suất chiếu..."

# Lấy ID đầu tiên từ mỗi bảng
MOVIE_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sN -e "SELECT id FROM movies LIMIT 1;" 2>/dev/null)
CINEMA_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sN -e "SELECT id FROM cinemas LIMIT 1;" 2>/dev/null)
ROOM_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sN -e "SELECT id FROM cinema_rooms WHERE cinema_id = $CINEMA_ID LIMIT 1;" 2>/dev/null)

if [ -z "$MOVIE_ID" ] || [ -z "$CINEMA_ID" ] || [ -z "$ROOM_ID" ]; then
    echo "Lỗi: Không tìm thấy đủ dữ liệu (phim, rạp, phòng chiếu)"
    echo "Vui lòng thêm dữ liệu vào database trước."
    exit 1
fi

echo ""
echo "Sẽ thêm suất chiếu với:"
echo "  - Movie ID: $MOVIE_ID"
echo "  - Cinema ID: $CINEMA_ID"
echo "  - Room ID: $ROOM_ID"
echo ""

# Lấy capacity của room
CAPACITY=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sN -e "SELECT capacity FROM cinema_rooms WHERE id = $ROOM_ID;" 2>/dev/null)
if [ -z "$CAPACITY" ]; then
    CAPACITY=70  # Default
fi

echo "  - Số ghế: $CAPACITY"
echo ""

# Thêm suất chiếu cho hôm nay và ngày mai
echo "Đang thêm suất chiếu..."

# Suất chiếu hôm nay
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
VALUES 
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '09:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '11:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '14:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '16:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '19:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '21:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW());
EOF

# Suất chiếu ngày mai
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
VALUES 
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW());
EOF

echo ""
echo "✅ Đã thêm suất chiếu thành công!"
echo ""
echo "=== Kiểm tra suất chiếu đã thêm ==="
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
SELECT 
    s.id,
    m.title_vietnamese as movie_title,
    c.name as cinema_name,
    r.room_name,
    s.show_date,
    s.show_time,
    s.price,
    s.available_seats,
    s.total_seats
FROM showtimes s
JOIN movies m ON s.movie_id = m.id
JOIN cinemas c ON s.cinema_id = c.id
JOIN cinema_rooms r ON s.room_id = r.id
WHERE s.show_date >= CURDATE()
ORDER BY s.show_date, s.show_time;
"

echo ""
echo "Hoàn tất! Bây giờ bạn có thể test đặt vé."



