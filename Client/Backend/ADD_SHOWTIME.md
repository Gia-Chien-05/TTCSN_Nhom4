# Hướng Dẫn Thêm Suất Chiếu

Có 2 cách để thêm suất chiếu vào hệ thống:

## Cách 1: Sử dụng SQL Script (Nhanh nhất)

1. Kiểm tra dữ liệu hiện có:
```sql
-- Xem danh sách phim
SELECT id, title, title_vietnamese FROM movies;

-- Xem danh sách rạp
SELECT id, name, city FROM cinemas;

-- Xem danh sách phòng chiếu
SELECT r.id, r.room_name, r.capacity, c.name as cinema_name 
FROM cinema_rooms r
JOIN cinemas c ON r.cinema_id = c.id;
```

2. Chỉnh sửa file `add-showtime.sql`:
   - Thay `movie_id = 1` bằng ID phim thực tế
   - Thay `cinema_id = 1` bằng ID rạp thực tế
   - Thay `room_id = 1` bằng ID phòng chiếu thực tế
   - Điều chỉnh giá vé nếu cần

3. Chạy script:
```bash
mysql -u your_username -p your_database_name < Backend/add-showtime.sql
```

Hoặc chạy trực tiếp trong MySQL:
```sql
source /var/www/TTCSN_Website-ban-ve-xem-phim/Backend/add-showtime.sql
```

## Cách 2: Sử dụng API Endpoint (Qua Postman/curl)

### Endpoint: `POST /api/showtimes`

**Request Body:**
```json
{
  "movieId": 1,
  "cinemaId": 1,
  "roomId": 1,
  "showDate": "2024-01-15",
  "showTime": "19:00:00",
  "price": 80000,
  "totalSeats": 70
}
```

**Ví dụ với curl:**
```bash
curl -X POST http://localhost:8080/api/showtimes \
  -H "Content-Type: application/json" \
  -d '{
    "movieId": 1,
    "cinemaId": 1,
    "roomId": 1,
    "showDate": "2024-01-15",
    "showTime": "19:00:00",
    "price": 80000,
    "totalSeats": 70
  }'
```

## Cách 3: Sử dụng MySQL trực tiếp

```sql
-- Thêm một suất chiếu
INSERT INTO showtimes (
    movie_id, 
    cinema_id, 
    room_id, 
    show_date, 
    show_time, 
    price, 
    available_seats, 
    total_seats, 
    status, 
    created_at, 
    updated_at
) VALUES (
    1,                          -- movie_id: ID của phim
    1,                          -- cinema_id: ID của rạp
    1,                          -- room_id: ID của phòng chiếu
    '2024-01-15',              -- show_date: Ngày chiếu (YYYY-MM-DD)
    '19:00:00',                -- show_time: Giờ chiếu (HH:MM:SS)
    80000,                     -- price: Giá vé
    70,                        -- available_seats: Số ghế còn trống
    70,                        -- total_seats: Tổng số ghế
    'AVAILABLE',               -- status: AVAILABLE, FULL, hoặc CANCELLED
    NOW(),                     -- created_at
    NOW()                      -- updated_at
);
```

## Lưu ý quan trọng:

1. **room_id phải thuộc cinema_id**: Phòng chiếu phải thuộc rạp đã chọn
2. **total_seats**: Nên lấy từ `cinema_rooms.capacity` hoặc đếm số ghế trong bảng `seats`
3. **available_seats**: Ban đầu bằng `total_seats`
4. **show_date**: Phải là ngày hiện tại hoặc tương lai
5. **status**: Mặc định là `'AVAILABLE'`

## Kiểm tra suất chiếu đã thêm:

```sql
SELECT 
    s.id,
    m.title as movie_title,
    c.name as cinema_name,
    r.room_name,
    s.show_date,
    s.show_time,
    s.price,
    s.available_seats,
    s.total_seats,
    s.status
FROM showtimes s
JOIN movies m ON s.movie_id = m.id
JOIN cinemas c ON s.cinema_id = c.id
JOIN cinema_rooms r ON s.room_id = r.id
WHERE s.show_date >= CURDATE()
ORDER BY s.show_date, s.show_time;
```



