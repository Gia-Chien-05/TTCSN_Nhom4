#!/bin/bash

# Script để thêm suất chiếu cho TẤT CẢ phim mới (ID 4-13)
echo "🚀 Thêm Suất Chiếu cho TẤT CẢ Phim Mới"
echo ""

DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

echo "📋 Thông tin:"
echo "   - Database: $DB_NAME"
echo "   - Thêm showtimes cho 7 ngày tới"
echo "   - Tất cả phim mới (ID 4-13)"
echo ""

mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" <<'EOF'
-- Thêm suất chiếu cho tất cả phim mới (ID >= 4)
INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
SELECT 
    m.id as movie_id,
    c.id as cinema_id,
    r.id as room_id,
    DATE_ADD(CURDATE(), INTERVAL day_offset.day_num DAY) as show_date,
    times.show_time,
    COALESCE(m.price, 85000) as price,
    r.capacity as available_seats,
    r.capacity as total_seats,
    'AVAILABLE' as status,
    NOW() as created_at,
    NOW() as updated_at
FROM movies m
CROSS JOIN cinemas c
CROSS JOIN cinema_rooms r
CROSS JOIN (
    SELECT 0 as day_num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
) day_offset
CROSS JOIN (
    SELECT '09:00:00' as show_time UNION
    SELECT '11:30:00' UNION
    SELECT '14:00:00' UNION
    SELECT '16:30:00' UNION
    SELECT '19:00:00' UNION
    SELECT '21:30:00'
) times
WHERE m.id >= 4  -- Chỉ thêm cho phim mới (ID 4-13)
AND r.cinema_id = c.id
AND NOT EXISTS (
    SELECT 1 FROM showtimes s 
    WHERE s.movie_id = m.id 
    AND s.cinema_id = c.id 
    AND s.room_id = r.id
    AND s.show_date = DATE_ADD(CURDATE(), INTERVAL day_offset.day_num DAY)
    AND s.show_time = times.show_time
)
ORDER BY m.id, c.id, r.id, day_offset.day_num, times.show_time;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Đã thêm suất chiếu thành công!"
    echo ""
    echo "📊 Thống kê:"
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT 
        m.id,
        m.title_vietnamese as movie,
        COUNT(s.id) as showtime_count
    FROM movies m
    LEFT JOIN showtimes s ON m.id = s.movie_id AND s.show_date >= CURDATE()
    WHERE m.id >= 4
    GROUP BY m.id, m.title_vietnamese
    ORDER BY m.id;
    "
    echo ""
    echo "📊 Tổng quan:"
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT 
        COUNT(*) as total_showtimes,
        COUNT(DISTINCT movie_id) as total_movies,
        COUNT(DISTINCT cinema_id) as total_cinemas,
        DATE_FORMAT(MIN(show_date), '%d/%m/%Y') as first_date,
        DATE_FORMAT(MAX(show_date), '%d/%m/%Y') as last_date
    FROM showtimes
    WHERE show_date >= CURDATE()
    AND movie_id >= 4;
    "
    echo ""
    echo "🎉 Hoàn tất! Tất cả phim mới đã có suất chiếu."
else
    echo "❌ Có lỗi xảy ra khi thêm suất chiếu."
    exit 1
fi


