# 🚀 Hướng Dẫn Setup và Chạy Dự Án CineMax

## 📋 Config Database

Dự án đã được config với:
```bash
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=cinemax_db
DB_USERNAME=root
DB_PASSWORD=
```

## ⚡ Quick Start

### 1. Import Database

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
./import-db.sh
```

**Lưu ý:** Nếu từ WSL, script sẽ tự động dùng IP Windows host. Nếu muốn dùng `127.0.0.1`, cần config MySQL trên Windows:

1. Mở `C:\xampp\mysql\bin\my.ini`
2. Tìm `[mysqld]` và thêm/sửa:
   ```ini
   [mysqld]
   bind-address = 0.0.0.0
   ```
3. Restart MySQL trong XAMPP

### 2. Chạy Dự Án

**Cách 1: Setup và Run tự động (Khuyên dùng)**
```bash
./setup-and-run.sh
```

**Cách 2: Chạy riêng**
```bash
# Import database
./import-db.sh

# Chạy Spring Boot
./run.sh
```

**Cách 3: Manual**
```bash
# Set environment variables
export DB_HOST=127.0.0.1
export DB_PORT=3306
export DB_DATABASE=cinemax_db
export DB_USERNAME=root
export DB_PASSWORD=

# Import database
mysql -h $DB_HOST -u $DB_USERNAME < database/schema.sql

# Chạy Spring Boot
mvn spring-boot:run
```

## 🔧 Troubleshooting

### ❌ "Can't connect to MySQL server"

**Nếu từ WSL:**
1. Lấy IP Windows host: `cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`
2. Thay `127.0.0.1` bằng IP đó trong script
3. Hoặc config MySQL `bind-address = 0.0.0.0` trên Windows

**Nếu chạy trên Windows:**
- Đảm bảo MySQL đang chạy trong XAMPP
- Kiểm tra port 3306 không bị block

### ❌ "Access denied for user"

```sql
GRANT ALL PRIVILEGES ON cinemax_db.* TO 'root'@'%' IDENTIFIED BY '';
FLUSH PRIVILEGES;
```

## 📝 Files Script

- `setup-and-run.sh` - Setup và chạy tự động (import DB + run app)
- `import-db.sh` - Chỉ import database
- `run.sh` - Chỉ chạy Spring Boot
- `grant-mysql-permissions.sh` - Grant quyền MySQL





