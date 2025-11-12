# 🎬 Test Movies API

## 📍 API Endpoints

Base URL: `http://localhost:8080/api`

### 1. Get All Movies
```bash
GET /api/movies
```

**Response:**
```json
[
  {
    "id": 1,
    "imdbId": "tt1375666",
    "title": "Inception",
    "titleVietnamese": "Kẻ Trộm Giấc Mơ",
    "description": "A mind-bending thriller about dream infiltration",
    "genre": "Sci-Fi, Action",
    "director": "Christopher Nolan",
    "actors": null,
    "releaseDate": "2010-07-16",
    "duration": 148,
    "rating": 8.8,
    "language": null,
    "country": null,
    "posterUrl": null,
    "trailerUrl": null,
    "status": "NOW_SHOWING",
    "price": 85000,
    "vipPrice": 120000
  }
]
```

### 2. Get Movie by ID
```bash
GET /api/movies/{id}
```

**Example:**
```bash
curl http://localhost:8080/api/movies/1
```

### 3. Get Movies by Status
```bash
GET /api/movies/status/{status}
```

**Status values:**
- `NOW_SHOWING` - Đang chiếu
- `COMING_SOON` - Sắp chiếu
- `ENDED` - Đã kết thúc

**Example:**
```bash
curl http://localhost:8080/api/movies/status/NOW_SHOWING
```

### 4. Search Movies
```bash
GET /api/movies/search?keyword={keyword}
```

**Example:**
```bash
curl "http://localhost:8080/api/movies/search?keyword=Matrix"
```

### 5. Get Movie by IMDB ID
```bash
GET /api/movies/imdb/{imdbId}
```

**Example:**
```bash
curl http://localhost:8080/api/movies/imdb/tt1375666
```

## 🧪 Test với Script

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
chmod +x test-movies-api.sh
./test-movies-api.sh
```

## 🌐 Test với Browser

Mở trình duyệt và truy cập:
- `http://localhost:8080/api/movies`
- `http://localhost:8080/api/movies/1`
- `http://localhost:8080/api/movies/status/NOW_SHOWING`

## 📝 Test với curl

### Get all movies:
```bash
curl http://localhost:8080/api/movies
```

### Get movie by ID:
```bash
curl http://localhost:8080/api/movies/1
```

### Get movies by status:
```bash
curl http://localhost:8080/api/movies/status/NOW_SHOWING
```

### Search movies:
```bash
curl "http://localhost:8080/api/movies/search?keyword=Matrix"
```

### Get movie by IMDB ID:
```bash
curl http://localhost:8080/api/movies/imdb/tt1375666
```

## 🎨 Format JSON (nếu có jq)

```bash
# Cài jq
sudo apt install jq -y

# Format JSON output
curl -s http://localhost:8080/api/movies | jq '.'
```

## ✅ Expected Response

Nếu API hoạt động đúng, bạn sẽ thấy JSON response với dữ liệu từ bảng `movies` trong database.

## 🐛 Troubleshooting

### ❌ "Connection refused"
- Kiểm tra ứng dụng đang chạy: `./run-simple.sh`
- Kiểm tra port 8080: `lsof -i:8080`

### ❌ "404 Not Found"
- Kiểm tra context path: `/api`
- Kiểm tra endpoint: `/api/movies` (không phải `/movies`)

### ❌ "Empty array []"
- Kiểm tra database có dữ liệu:
  ```bash
  mysql -h 127.0.0.1 -u root -e "USE cinemax_db; SELECT * FROM movies;"
  ```
- Nếu không có dữ liệu, import lại:
  ```bash
  ./import-db-simple.sh
  ```

## 📊 Response Format

Tất cả endpoints trả về JSON với cấu trúc:
```json
{
  "id": 1,
  "imdbId": "tt1375666",
  "title": "Inception",
  "titleVietnamese": "Kẻ Trộm Giấc Mơ",
  "description": "...",
  "genre": "Sci-Fi, Action",
  "director": "Christopher Nolan",
  "releaseDate": "2010-07-16",
  "duration": 148,
  "rating": 8.8,
  "status": "NOW_SHOWING",
  "price": 85000,
  "vipPrice": 120000
}
```

---

**🎉 API đã sẵn sàng! Hãy test ngay!**





