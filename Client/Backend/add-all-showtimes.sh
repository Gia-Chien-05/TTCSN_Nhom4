#!/bin/bash

# Script để thêm suất chiếu cho TẤT CẢ phim
# Sử dụng: ./add-all-showtimes.sh

echo "=== Thêm Suất Chiếu cho TẤT CẢ Phim ==="
echo ""

DB_USER="${DB_USERNAME:-root}"
DB_PASS="${DB_PASSWORD:-}"
DB_NAME="${DB_DATABASE:-cinemax_db}"

# Lấy danh sách phim
echo "Đang lấy danh sách phim..."
MOVIES=$(mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -sN -e "SELECT id FROM movies;")

if [ -z "$MOVIES" ]; then
    echo "❌ Không tìm thấy phim nào trong database!"
    exit 1
fi

# Lấy danh sách rạp và phòng
CINEMAS=$(mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -sN -e "SELECT DISTINCT cinema_id, (SELECT id FROM cinema_rooms WHERE cinema_id = c.id LIMIT 1) as room_id FROM cinemas c WHERE EXISTS (SELECT 1 FROM cinema_rooms WHERE cinema_id = c.id);")

if [ -z "$CINEMAS" ]; then
    echo "❌ Không tìm thấy rạp và phòng chiếu!"
    exit 1
fi

echo "✅ Tìm thấy:"
MOVIE_COUNT=$(echo "$MOVIES" | wc -l)
echo "   - $MOVIE_COUNT phim"
CINEMA_COUNT=$(echo "$CINEMAS" | wc -l)
echo "   - $CINEMA_COUNT rạp có phòng chiếu"
echo ""

# Thời gian chiếu
TIMES=("09:00:00" "11:30:00" "14:00:00" "16:30:00" "19:00:00" "21:30:00")
PRICE=80000

# Thêm suất chiếu cho 7 ngày tới (hôm nay + 6 ngày tiếp theo)
echo "Đang thêm suất chiếu cho 7 ngày tới..."

mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" <<'EOF'
-- Tạo stored procedure để thêm suất chiếu
DROP PROCEDURE IF EXISTS AddShowtimesForAllMovies;

DELIMITER //

CREATE PROCEDURE AddShowtimesForAllMovies()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_movie_id BIGINT;
    DECLARE v_cinema_id BIGINT;
    DECLARE v_room_id BIGINT;
    DECLARE v_capacity INT;
    DECLARE v_day_offset INT;
    DECLARE v_time VARCHAR(10);
    DECLARE cur_movies CURSOR FOR SELECT id FROM movies;
    DECLARE cur_cinemas CURSOR FOR 
        SELECT DISTINCT 
            c.id as cinema_id,
            (SELECT id FROM cinema_rooms WHERE cinema_id = c.id LIMIT 1) as room_id,
            (SELECT capacity FROM cinema_rooms WHERE cinema_id = c.id LIMIT 1) as capacity
        FROM cinemas c 
        WHERE EXISTS (SELECT 1 FROM cinema_rooms WHERE cinema_id = c.id);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Duyệt qua từng phim
    OPEN cur_movies;
    movie_loop: LOOP
        FETCH cur_movies INTO v_movie_id;
        IF done THEN
            LEAVE movie_loop;
        END IF;

        -- Duyệt qua từng rạp
        OPEN cur_cinemas;
        cinema_loop: LOOP
            FETCH cur_cinemas INTO v_cinema_id, v_room_id, v_capacity;
            IF done THEN
                SET done = FALSE;
                LEAVE cinema_loop;
            END IF;

            -- Thêm suất chiếu cho 7 ngày tới
            SET v_day_offset = 0;
            WHILE v_day_offset < 7 DO
                -- Thêm 6 suất mỗi ngày
                INSERT INTO showtimes (movie_id, cinema_id, room_id, show_date, show_time, price, available_seats, total_seats, status, created_at, updated_at)
                VALUES 
                (v_movie_id, v_cinema_id, v_room_id, DATE_ADD(CURDATE(), INTERVAL v_day_offset DAY), '09:00:00', 80000, v_capacity, v_capacity, 'AVAILABLE', NOW(), NOW()),
                (v_movie_id, v_cinema_id, v_room_id, DATE_ADD(CURDATE(), INTERVAL v_day_offset DAY), '11:30:00', 80000, v_capacity, v_capacity, 'AVAILABLE', NOW(), NOW()),
                (v_movie_id, v_cinema_id, v_room_id, DATE_ADD(CURDATE(), INTERVAL v_day_offset DAY), '14:00:00', 80000, v_capacity, v_capacity, 'AVAILABLE', NOW(), NOW()),
                (v_movie_id, v_cinema_id, v_room_id, DATE_ADD(CURDATE(), INTERVAL v_day_offset DAY), '16:30:00', 80000, v_capacity, v_capacity, 'AVAILABLE', NOW(), NOW()),
                (v_movie_id, v_cinema_id, v_room_id, DATE_ADD(CURDATE(), INTERVAL v_day_offset DAY), '19:00:00', 80000, v_capacity, v_capacity, 'AVAILABLE', NOW(), NOW()),
                (v_movie_id, v_cinema_id, v_room_id, DATE_ADD(CURDATE(), INTERVAL v_day_offset DAY), '21:30:00', 80000, v_capacity, v_capacity, 'AVAILABLE', NOW(), NOW())
                ON DUPLICATE KEY UPDATE updated_at = NOW();
                
                SET v_day_offset = v_day_offset + 1;
            END WHILE;

        END LOOP;
        CLOSE cur_cinemas;
        SET done = FALSE;

    END LOOP;
    CLOSE cur_movies;
END//

DELIMITER ;

-- Chạy stored procedure
CALL AddShowtimesForAllMovies();

-- Xóa stored procedure
DROP PROCEDURE IF EXISTS AddShowtimesForAllMovies;
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Đã thêm suất chiếu thành công!"
    echo ""
    echo "=== Thống kê ==="
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT 
        COUNT(*) as total_showtimes,
        COUNT(DISTINCT movie_id) as total_movies,
        COUNT(DISTINCT cinema_id) as total_cinemas,
        MIN(show_date) as first_date,
        MAX(show_date) as last_date
    FROM showtimes
    WHERE show_date >= CURDATE();
    "
    echo ""
    echo "=== Ví dụ suất chiếu đã thêm ==="
    mysql -u "$DB_USER" ${DB_PASS:+-p"$DB_PASS"} "$DB_NAME" -e "
    SELECT 
        m.title_vietnamese as movie,
        c.name as cinema,
        DATE_FORMAT(s.show_date, '%d/%m/%Y') as date,
        TIME_FORMAT(s.show_time, '%H:%i') as time,
        s.available_seats
    FROM showtimes s
    JOIN movies m ON s.movie_id = m.id
    JOIN cinemas c ON s.cinema_id = c.id
    WHERE s.show_date >= CURDATE()
    ORDER BY s.show_date, s.show_time, m.title_vietnamese
    LIMIT 20;
    "
    echo ""
    echo "🎉 Hoàn tất! Đã thêm suất chiếu cho tất cả phim trong 7 ngày tới."
else
    echo ""
    echo "❌ Có lỗi xảy ra."
fi



