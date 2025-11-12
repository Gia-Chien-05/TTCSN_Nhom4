# 🔧 Hướng Dẫn Setup MySQL Connection từ WSL đến Windows XAMPP

## 📋 Tổng Quan

Khi bạn chạy WSL và muốn connect đến MySQL trên Windows XAMPP, cần config đặc biệt vì:
- WSL có network riêng, `localhost` trong WSL không trỏ đến Windows
- MySQL trên XAMPP mặc định chỉ listen trên Windows localhost
- Cần dùng IP của Windows host để connect

---

## 🎯 Bước 1: Lấy IP của Windows Host từ WSL

### Cách 1: Dùng script helper (Khuyên dùng)

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
chmod +x get-windows-host.sh
./get-windows-host.sh
```

Script sẽ hiển thị IP của Windows host (thường là `172.x.x.1` hoặc `10.255.255.254`)

### Cách 2: Lấy thủ công

```bash
# Lấy IP từ /etc/resolv.conf
cat /etc/resolv.conf | grep nameserver | awk '{print $2}'

# Hoặc lấy từ ip route
ip route show | grep -i default | awk '{ print $3}'
```

**Lưu ý:** IP này có thể thay đổi mỗi khi restart WSL. Nếu thay đổi, cần update lại config.

---

## 🔧 Bước 2: Config MySQL trên XAMPP để Accept Remote Connections

### 2.1. Mở file `my.ini` hoặc `my.cnf` trong XAMPP

**Windows Path:** `C:\xampp\mysql\bin\my.ini`

Hoặc tìm file config:
- `C:\xampp\mysql\bin\my.ini` (Windows)
- `C:\xampp\mysql\bin\my.cnf` (nếu có)

### 2.2. Tìm và sửa section `[mysqld]`

Tìm dòng:
```ini
bind-address = 127.0.0.1
```

**Thay đổi thành:**
```ini
bind-address = 0.0.0.0
```

Hoặc comment dòng đó:
```ini
# bind-address = 127.0.0.1
```

**⚠️ Lưu ý:** `bind-address = 0.0.0.0` cho phép MySQL listen trên tất cả interfaces, bao gồm cả từ WSL.

### 2.3. Restart MySQL trong XAMPP

1. Mở XAMPP Control Panel
2. Stop MySQL
3. Start lại MySQL

---

## 🔐 Bước 3: Tạo User MySQL cho Remote Access (Nếu cần)

### Cách 1: Dùng root user (Không khuyên dùng cho production)

Từ Windows PowerShell hoặc MySQL Command Line:

```sql
-- Login vào MySQL
mysql -u root -p

-- Cho phép root connect từ bất kỳ host nào (chỉ dùng cho development)
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

### Cách 2: Tạo user riêng (Khuyên dùng)

```sql
-- Tạo user mới
CREATE USER 'cinemax_user'@'%' IDENTIFIED BY 'your_password';

-- Cấp quyền cho database cinemax_db
GRANT ALL PRIVILEGES ON cinemax_db.* TO 'cinemax_user'@'%';
FLUSH PRIVILEGES;
```

---

## 🧪 Bước 4: Test Connection từ WSL

### 4.1. Lấy IP Windows host

```bash
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
echo "Windows IP: $WINDOWS_IP"
```

### 4.2. Test MySQL connection

```bash
# Test với root user (nếu password rỗng)
mysql -h $WINDOWS_IP -u root -p

# Hoặc test với user khác
mysql -h $WINDOWS_IP -u cinemax_user -p
```

Nếu connect thành công, bạn sẽ thấy MySQL prompt.

### 4.3. Test ping đến Windows host

```bash
ping -c 3 $WINDOWS_IP
```

---

## 📝 Bước 5: Update application.properties

### Option 1: Dùng IP tĩnh (Nhanh nhưng cần update khi IP thay đổi)

Mở file `Backend/src/main/resources/application.properties`:

```properties
# Thay localhost bằng IP Windows host
# Ví dụ: 172.20.10.1 hoặc 10.255.255.254
spring.datasource.url=jdbc:mysql://172.20.10.1:3306/cinemax_db?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true&createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=
```

**⚠️ Lưu ý:** IP này có thể thay đổi khi restart WSL, cần update lại.

### Option 2: Dùng environment variable (Khuyên dùng)

Update `application.properties`:

```properties
# Dùng ${MYSQL_HOST} để linh hoạt
spring.datasource.url=jdbc:mysql://${MYSQL_HOST:localhost}:3306/cinemax_db?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true&createDatabaseIfNotExist=true
spring.datasource.username=${MYSQL_USER:root}
spring.datasource.password=${MYSQL_PASSWORD:}
```

Tạo script `run.sh` để tự động lấy IP:

```bash
#!/bin/bash
export MYSQL_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export MYSQL_USER=root
export MYSQL_PASSWORD=
mvn spring-boot:run
```

---

## 🗄️ Bước 6: Import Database Schema

### Cách 1: Dùng MySQL command line

```bash
# Lấy IP Windows host
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Import schema
mysql -h $WINDOWS_IP -u root -p < Backend/database/schema.sql
```

### Cách 2: Dùng script helper

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
chmod +x import-database.sh
./import-database.sh
```

---

## ✅ Bước 7: Verify Connection

### Test từ Java Application

1. Start Spring Boot application:
```bash
cd Backend
mvn spring-boot:run
```

2. Kiểm tra logs, nếu thấy:
```
HikariPool-1 - Starting...
HikariPool-1 - Start completed.
```

Thì connection đã thành công! 🎉

### Test từ MySQL client

```bash
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
mysql -h $WINDOWS_IP -u root -p -e "USE cinemax_db; SHOW TABLES;"
```

---

## 🐛 Troubleshooting

### ❌ Lỗi: "Access denied for user"

**Giải pháp:**
- Kiểm tra user và password trong `application.properties`
- Đảm bảo đã grant quyền cho user từ IP WSL:
```sql
GRANT ALL PRIVILEGES ON cinemax_db.* TO 'root'@'%' IDENTIFIED BY '';
FLUSH PRIVILEGES;
```

### ❌ Lỗi: "Can't connect to MySQL server"

**Giải pháp:**
1. Kiểm tra MySQL đang chạy trên XAMPP
2. Kiểm tra `bind-address` trong `my.ini` đã set `0.0.0.0`
3. Kiểm tra firewall Windows không block port 3306
4. Test ping đến Windows host:
```bash
ping -c 3 $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
```

### ❌ Lỗi: IP thay đổi sau khi restart WSL

**Giải pháp:**
- Dùng environment variable trong `application.properties`
- Tạo script tự động lấy IP mỗi lần chạy
- Hoặc dùng static IP cho WSL (cần config thêm)

### ❌ Lỗi: "The server time zone value is unrecognized"

**Giải pháp:**
- Đảm bảo connection string có `serverTimezone=Asia/Ho_Chi_Minh`
- Hoặc set timezone trong MySQL:
```sql
SET GLOBAL time_zone = '+07:00';
```

---

## 📚 Quick Reference

### Lấy IP Windows host:
```bash
cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
```

### Test MySQL connection:
```bash
mysql -h <WINDOWS_IP> -u root -p
```

### Import database:
```bash
mysql -h <WINDOWS_IP> -u root -p < Backend/database/schema.sql
```

### Check MySQL bind-address:
```ini
# File: C:\xampp\mysql\bin\my.ini
[mysqld]
bind-address = 0.0.0.0
```

---

## 🎯 Best Practices

1. **Development:** Dùng root user với password rỗng (OK)
2. **Production:** Tạo user riêng với password mạnh
3. **IP Management:** Dùng environment variable thay vì hardcode IP
4. **Security:** Chỉ mở `bind-address = 0.0.0.0` khi cần thiết, đóng lại sau khi dev xong

---

**💡 Tips:** 
- Lưu IP Windows host vào file `.env` hoặc script để dễ reuse
- Tạo alias trong `.bashrc` hoặc `.zshrc`:
```bash
alias mysql-win='mysql -h $(cat /etc/resolv.conf | grep nameserver | awk '\''{print $2}'\'') -u root -p'
```






