# 🎬 CineMax Backend API

Backend API cho Website Bán Vé Xem Phim được xây dựng bằng **Spring Boot 3.1.5** và **Java 17**.

## 📋 Mục Lục

- [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
- [Cài Đặt](#cài-đặt)
- [Cấu Hình Database](#cấu-hình-database)
- [Chạy Ứng Dụng](#chạy-ứng-dụng)
- [API Endpoints](#api-endpoints)
- [Cấu Trúc Project](#cấu-trúc-project)

## 🔧 Yêu Cầu Hệ Thống

- **Java**: JDK 17 trở lên
- **Maven**: 3.6+ 
- **MySQL**: 8.0+ hoặc PostgreSQL 13+
- **IDE**: IntelliJ IDEA / Eclipse / VS Code

## 📦 Cài Đặt

### 1. Clone Repository

```bash
cd Backend
```

### 2. Cài đặt Dependencies

```bash
mvn clean install
```

## 🗄️ Cấu Hình Database

### 1. Tạo Database

Chạy file SQL để tạo database và các bảng:

```bash
mysql -u root -p < database/schema.sql
```

Hoặc mở MySQL và chạy:

```sql
source database/schema.sql;
```

### 2. Cấu hình trong `application.properties`

Sửa thông tin kết nối database trong `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/cinemax_db
spring.datasource.username=root
spring.datasource.password=your_password
```

## 🚀 Chạy Ứng Dụng

### Cách 1: Chạy từ IDE

1. Mở project trong IntelliJ IDEA / Eclipse
2. Chạy file `CineMaxApplication.java`
3. API sẽ chạy tại: `http://localhost:8080/api`

### Cách 2: Chạy bằng Maven

```bash
mvn spring-boot:run
```

### Cách 3: Build và chạy JAR

```bash
mvn clean package
java -jar target/cinemax-api-1.0.0.jar
```

## 📡 API Endpoints

Base URL: `http://localhost:8080/api`

### 🔐 Authentication

#### Đăng ký
```http
POST /auth/register
Content-Type: application/json

{
  "fullName": "Nguyễn Văn A",
  "email": "user@example.com",
  "phone": "0123456789",
  "password": "password123"
}
```

#### Đăng nhập
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### 🎬 Movies

#### Lấy tất cả phim
```http
GET /movies
```

#### Lấy phim theo trạng thái
```http
GET /movies/status/{status}
```
Status: `NOW_SHOWING`, `COMING_SOON`, `ENDED`

#### Lấy phim theo ID
```http
GET /movies/{id}
```

#### Lấy phim theo IMDb ID
```http
GET /movies/imdb/{imdbId}
```

#### Tìm kiếm phim
```http
GET /movies/search?keyword=matrix
```

### 🏢 Cinemas

#### Lấy tất cả rạp
```http
GET /cinemas
```

#### Lấy rạp theo ID
```http
GET /cinemas/{id}
```

#### Lấy rạp theo thành phố
```http
GET /cinemas/city/{city}
```

#### Lấy danh sách thành phố
```http
GET /cinemas/cities
```

#### Lọc rạp
```http
GET /cinemas/filter?city=Hồ Chí Minh&district=Quận 1
```

### 🎫 Showtimes

#### Lấy suất chiếu theo ngày
```http
GET /showtimes/date/2024-01-15
```

#### Lấy suất chiếu theo ngày và rạp
```http
GET /showtimes/date/2024-01-15/cinema/1
```

#### Lấy suất chiếu theo ngày và phim
```http
GET /showtimes/date/2024-01-15/movie/1
```

#### Lấy suất chiếu theo ID
```http
GET /showtimes/{id}
```

### 🎟️ Bookings

#### Tạo đặt vé
```http
POST /bookings?userId=1
Content-Type: application/json

{
  "showtimeId": 1,
  "seatIds": [1, 2, 3],
  "paymentMethod": "MOMO",
  "promotionCode": "PROMO2024",
  "notes": "Ghi chú"
}
```

#### Lấy đặt vé theo mã
```http
GET /bookings/code/{bookingCode}
```

#### Lấy đặt vé của user
```http
GET /bookings/user/{userId}
```

#### Xác nhận thanh toán
```http
PUT /bookings/{bookingCode}/confirm-payment
```

## 📁 Cấu Trúc Project

```
Backend/
├── src/
│   ├── main/
│   │   ├── java/com/cinemax/
│   │   │   ├── config/          # Cấu hình (Security, JWT, CORS)
│   │   │   ├── controller/      # REST Controllers
│   │   │   ├── dto/             # Data Transfer Objects
│   │   │   ├── entity/          # Entity models (JPA)
│   │   │   ├── exception/       # Exception handlers
│   │   │   ├── repository/      # Repository interfaces (JPA)
│   │   │   ├── service/         # Business logic layer
│   │   │   └── CineMaxApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── database/
│   └── schema.sql               # Database schema
├── pom.xml
└── README.md
```

## 🔑 Tính Năng Chính

- ✅ **Authentication & Authorization** - JWT based authentication
- ✅ **CRUD Operations** - Đầy đủ các thao tác CRUD
- ✅ **Movie Management** - Quản lý phim, tìm kiếm
- ✅ **Cinema Management** - Quản lý rạp chiếu
- ✅ **Showtime Management** - Quản lý suất chiếu
- ✅ **Booking System** - Hệ thống đặt vé với ghế ngồi
- ✅ **Payment Integration** - Hỗ trợ nhiều phương thức thanh toán
- ✅ **Promotion System** - Hệ thống khuyến mãi

## 🛠️ Công Nghệ Sử Dụng

- **Spring Boot 3.1.5** - Framework chính
- **Spring Data JPA** - ORM layer
- **Spring Security** - Security & Authentication
- **JWT (JJWT)** - Token-based authentication
- **MySQL** - Database
- **Lombok** - Giảm boilerplate code
- **Maven** - Build tool

## 📝 Notes

- Database sẽ tự động tạo/update khi chạy ứng dụng (với `spring.jpa.hibernate.ddl-auto=update`)
- CORS đã được cấu hình để cho phép frontend kết nối
- JWT secret key có thể thay đổi trong `application.properties`
- API base path: `/api` (có thể thay đổi trong `application.properties`)

## 🐛 Troubleshooting

### Lỗi kết nối database:
- Kiểm tra MySQL đã chạy chưa
- Kiểm tra username/password trong `application.properties`
- Kiểm tra database `cinemax_db` đã được tạo chưa

### Lỗi port đã được sử dụng:
- Đổi port trong `application.properties`: `server.port=8081`

### Lỗi compile:
- Chạy `mvn clean install` để rebuild
- Kiểm tra Java version: `java -version` (cần JDK 17+)

## 📞 Support

Nếu có vấn đề, vui lòng tạo issue hoặc liên hệ team phát triển.

---

**Happy Coding! 🎉**


