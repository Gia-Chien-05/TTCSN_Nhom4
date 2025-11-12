# Hướng Dẫn Restart Backend

Backend cần được restart để load JWT Authentication Filter mới.

## Cách 1: Restart thủ công

1. Tìm terminal đang chạy backend
2. Nhấn `Ctrl+C` để dừng
3. Chạy lại:
```bash
cd Backend
mvn spring-boot:run
```

## Cách 2: Dùng script

```bash
./start-backend.sh
```

## Cách 3: Nếu dùng IDE

- Stop application
- Run lại `CineMaxApplication`

## Kiểm tra đã load JWT Filter

Sau khi restart, khi đặt vé, bạn sẽ thấy log trong console:
```
JWT Filter - Path: /api/bookings, Token: Present
JWT Filter - Token valid: true
JWT Filter - Email: ...
JWT Filter - Authentication set for: ...
```

Nếu không thấy log này, có nghĩa là filter chưa được load hoặc có lỗi.



