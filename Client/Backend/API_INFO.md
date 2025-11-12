# 🎬 CineMax API - Thông Tin

## ✅ Ứng dụng đã chạy thành công!

### 📍 API Endpoints

Base URL: `http://localhost:8080/api`

### 🔐 Security

**Generated Password (Development):**
```
0921f2cc-7ac1-4029-8490-d3de356d0e8c
```

⚠️ **Lưu ý:** Đây là password tự động tạo cho development. Cần config security trước khi deploy production.

### 📝 API Endpoints Có Thể Có

Dựa vào controllers trong project:

- **Auth**
  - `POST /api/auth/register` - Đăng ký
  - `POST /api/auth/login` - Đăng nhập

- **Movies**
  - `GET /api/movies` - Danh sách phim
  - `GET /api/movies/{id}` - Chi tiết phim

- **Cinemas**
  - `GET /api/cinemas` - Danh sách rạp
  - `GET /api/cinemas/{id}` - Chi tiết rạp

- **Showtimes**
  - `GET /api/showtimes` - Danh sách suất chiếu
  - `GET /api/showtimes/{id}` - Chi tiết suất chiếu

- **Bookings**
  - `GET /api/bookings` - Danh sách đặt vé
  - `POST /api/bookings` - Tạo đặt vé
  - `GET /api/bookings/{id}` - Chi tiết đặt vé

### 🧪 Test API

**Sử dụng curl:**
```bash
# Test API health
curl http://localhost:8080/api

# Test movies endpoint
curl http://localhost:8080/api/movies
```

**Sử dụng Postman hoặc Browser:**
- Mở: `http://localhost:8080/api/movies`
- Hoặc: `http://localhost:8080/api/cinemas`

### 📊 Database

- **Host:** `10.255.255.254` (Windows IP từ WSL)
- **Port:** `3306`
- **Database:** `cinemax_db`
- **Username:** `root`
- **Password:** (empty)

### 🔧 Các Script Hữu Ích

```bash
# Chạy ứng dụng
./run-simple.sh

# Import database
./import-db-simple.sh

# Xóa và import lại database
./drop-and-import.sh

# Cài Java + Maven
./setup-java-maven.sh
```

### 🛑 Stop Application

Nhấn `Ctrl + C` trong terminal để dừng ứng dụng.

### 📝 Logs

Logs hiển thị:
- ✅ Database connection: `HikariPool-1 - Start completed`
- ✅ Server started: `Tomcat started on port(s): 8080`
- ✅ Application started: `Started CineMaxApplication`

### 🐛 Troubleshooting

**Nếu gặp lỗi connection:**
1. Kiểm tra MySQL đang chạy trong XAMPP
2. Kiểm tra IP Windows host: `cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`
3. Test MySQL connection: `mysql -h 10.255.255.254 -u root -p`

**Nếu port 8080 đã được dùng:**
- Sửa `server.port` trong `application.properties`
- Hoặc kill process đang dùng port 8080:
  ```bash
  lsof -ti:8080 | xargs kill -9
  ```

---

**🎉 Chúc mừng! API đã sẵn sàng sử dụng!**





