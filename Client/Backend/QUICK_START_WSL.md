# 🚀 Quick Start - Setup MySQL từ WSL đến Windows XAMPP

## ⚡ Các bước nhanh (5 phút)

### 1️⃣ Lấy IP Windows Host
```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
./get-windows-host.sh
```

**Kết quả:** IP Windows host (ví dụ: `10.255.255.254`)

### 2️⃣ Config MySQL trên XAMPP

Mở file `C:\xampp\mysql\bin\my.ini` và tìm section `[mysqld]`:

```ini
[mysqld]
bind-address = 0.0.0.0
```

**Lưu ý:** Thay `127.0.0.1` thành `0.0.0.0` để MySQL listen trên tất cả interfaces.

Restart MySQL trong XAMPP Control Panel.

### 3️⃣ Grant quyền cho user (nếu cần)

Từ MySQL Command Line hoặc phpMyAdmin:

```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

### 4️⃣ Import Database

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
./import-database.sh
```

### 5️⃣ Test Connection

```bash
# Test MySQL connection
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
mysql -h $WINDOWS_IP -u root -p
```

### 6️⃣ Chạy Spring Boot Application

**Cách 1: Dùng script tự động (Khuyên dùng)**
```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
./run-with-mysql.sh
```

**Cách 2: Manual**
```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
export MYSQL_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export MYSQL_USER=root
export MYSQL_PASSWORD=
mvn spring-boot:run
```

---

## 📋 Checklist

- [ ] Lấy được IP Windows host
- [ ] Config MySQL `bind-address = 0.0.0.0`
- [ ] Restart MySQL trong XAMPP
- [ ] Grant quyền cho user MySQL
- [ ] Test MySQL connection từ WSL
- [ ] Import database schema
- [ ] Chạy Spring Boot application thành công

---

## 🐛 Lỗi thường gặp

### ❌ "Can't connect to MySQL server"
→ Kiểm tra `bind-address = 0.0.0.0` trong `my.ini` và restart MySQL

### ❌ "Access denied for user"
→ Chạy lại lệnh GRANT:
```sql
GRANT ALL PRIVILEGES ON cinemax_db.* TO 'root'@'%' IDENTIFIED BY '';
FLUSH PRIVILEGES;
```

### ❌ IP thay đổi sau restart WSL
→ Dùng script `run-with-mysql.sh` để tự động lấy IP mới

---

## 📚 Xem thêm

Chi tiết đầy đủ: `SETUP_MYSQL_WSL.md`






