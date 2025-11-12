#!/bin/bash

# Script đơn giản để thêm suất chiếu
# Sử dụng: ./add-showtime-simple.sh

echo "=== Thêm Suất Chiếu vào Database ==="
echo ""

# Thông tin database mặc định (có thể thay đổi)
DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo ""

# Kiểm tra dữ liệu hiện có
echo "=== Kiểm tra dữ liệu hiện có ==="
echo ""
echo "1. Danh sách phim:"
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "SELECT id, title_vietnamese as title FROM movies LIMIT 5;" 2>/dev/null || {
    echo "⚠️  Không thể kết nối database. Vui lòng kiểm tra:"
    echo "   - Database đã được tạo chưa?"
    echo "   - Username và password đúng chưa?"
    echo ""
    read -p "Nhấn Enter để thử lại với thông tin khác..."
    read -p "Database User [root]: " DB_USER
    DB_USER=${DB_USER:-root}
    read -sp "Database Password: " DB_PASS
    echo ""
    read -p "Database Name [cinemax_db]: " DB_NAME
    DB_NAME=${DB_NAME:-cinemax_db}
}

echo ""
echo "2. Danh sách rạp:"
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "SELECT id, name, city FROM cinemas LIMIT 5;"

echo ""
echo "3. Danh sách phòng chiếu:"
mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "SELECT r.id, r.room_name, r.capacity, c.name as cinema_name FROM cinema_rooms r JOIN cinemas c ON r.cinema_id = c.id LIMIT 5;"

echo ""
echo "=== Lấy ID để thêm suất chiếu ==="
MOVIE_ID=$(mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -sN -e "SELECT id FROM movies LIMIT 1;" 2>/dev/null)
CINEMA_ID=$(mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -sN -e "SELECT id FROM cinemas LIMIT 1;" 2>/dev/null)
ROOM_ID=$(mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -sN -e "SELECT id FROM cinema_rooms WHERE cinema_id = $CINEMA_ID LIMIT 1;" 2>/dev/null)

if [ -z "$MOVIE_ID" ] || [ -z "$CINEMA_ID" ] || [ -z "$ROOM_ID" ]; then
    echo "❌ Lỗi: Không tìm thấy đủ dữ liệu!"
    echo "   Cần có ít nhất: 1 phim, 1 rạp, 1 phòng chiếu"
    exit 1
fi

echo "✅ Tìm thấy:"
echo "   Movie ID: $MOVIE_ID"
echo "   Cinema ID: $CINEMA_ID"
echo "   Room ID: $ROOM_ID"

CAPACITY=$(mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -sN -e "SELECT capacity FROM cinema_rooms WHERE id = $ROOM_ID;" 2>/dev/null)
CAPACITY=${CAPACITY:-70}
echo "   Capacity: $CAPACITY"
echo ""

read -p "Nhấn Enter để thêm suất chiếu (hôm nay và ngày mai)..."

# Thêm suất chiếu
echo ""
echo "Đang thêm suất chiếu..."

mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" <<EOF
-- Suất chiếu hôm nay
INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
VALUES 
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '09:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '11:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '14:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '16:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '19:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, CURDATE(), '21:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW());

-- Suất chiếu ngày mai
INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
VALUES 
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:00:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW()),
($MOVIE_ID, $CINEMA_ID, $ROOM_ID, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:30:00', 80000, $CAPACITY, $CAPACITY, 'AVAILABLE', NOW(), NOW());
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Đã thêm suất chiếu thành công!"
    echo ""
    echo "=== Suất chiếu đã thêm ==="
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT 
        s.id,
        m.title_vietnamese as movie_title,
        c.name as cinema_name,
        r.room_name,
        DATE_FORMAT(s.show_date, '%d/%m/%Y') as date,
        TIME_FORMAT(s.show_time, '%H:%i') as time,
        CONCAT(FORMAT(s.price, 0), 'đ') as price,
        s.available_seats,
        s.total_seats
    FROM showtimes s
    JOIN movies m ON s.movie_id = m.id
    JOIN cinemas c ON s.cinema_id = c.id
    JOIN cinema_rooms r ON s.room_id = r.id
    WHERE s.show_date >= CURDATE()
    ORDER BY s.show_date, s.show_time
    LIMIT 12;
    "
    echo ""
    echo "🎉 Hoàn tất! Bây giờ bạn có thể test đặt vé trên website."
else
    echo ""
    echo "❌ Có lỗi xảy ra khi thêm suất chiếu."
fi



