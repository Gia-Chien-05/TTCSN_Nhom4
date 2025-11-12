# 🔐 Hướng Dẫn Grant MySQL Permissions từ WSL

## 🎯 Bước 3: Grant quyền MySQL cho Remote Access

### Cách 1: Dùng Script Helper (Khuyên dùng)

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
./grant-mysql-permissions.sh
```

Script sẽ tự động:
1. Lấy IP Windows host
2. Hỏi MySQL username (mặc định: root)
3. Hỏi MySQL password (Enter nếu không có)
4. Chạy lệnh GRANT tự động

---

### Cách 2: Chạy trực tiếp từ Command Line

#### Bước 1: Lấy IP Windows host

```bash
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
echo "Windows IP: $WINDOWS_IP"
```

**Kết quả:** `10.255.255.254` (hoặc IP khác tùy WSL)

#### Bước 2: Connect MySQL từ WSL

```bash
# Với password rỗng (XAMPP mặc định)
mysql -h 10.255.255.254 -u root

# Hoặc với password (nếu có)
mysql -h 10.255.255.254 -u root -p
```

**Lưu ý:** Nếu lỗi "Can't connect", đảm bảo đã config `bind-address = 0.0.0.0` trong `my.ini` và restart MySQL.

#### Bước 3: Chạy lệnh GRANT trong MySQL

Sau khi connect thành công, bạn sẽ thấy MySQL prompt: `mysql>`

Chạy các lệnh sau:

```sql
-- Grant quyền cho root user (password rỗng)
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;

-- Hoặc nếu có password
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'your_password' WITH GRANT OPTION;

-- Apply changes
FLUSH PRIVILEGES;

-- Kiểm tra quyền đã được grant
SHOW GRANTS FOR 'root'@'%';
```

**Lưu ý:**
- `'%'` nghĩa là cho phép connect từ bất kỳ host nào
- `''` là password rỗng (XAMPP mặc định)
- Nếu có password, thay `''` bằng password của bạn

#### Bước 4: Exit MySQL

```sql
exit;
```

---

### Cách 3: Chạy SQL từ file (One-liner)

```bash
# Lấy IP Windows host
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Grant quyền với password rỗng
mysql -h $WINDOWS_IP -u root <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Hoặc với password (nếu có)
mysql -h $WINDOWS_IP -u root -p <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'your_password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
```

---

### Cách 4: Chạy SQL command trực tiếp (One-liner)

```bash
# Lấy IP Windows host
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Grant quyền (password rỗng)
mysql -h $WINDOWS_IP -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Hoặc với password
mysql -h $WINDOWS_IP -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'your_password' WITH GRANT OPTION; FLUSH PRIVILEGES;"
```

---

## ✅ Verify Permissions

Sau khi grant quyền, test lại connection:

```bash
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
mysql -h $WINDOWS_IP -u root -e "SHOW GRANTS FOR 'root'@'%';"
```

**Kết quả mong đợi:**
```
+-------------------------------------------------------------+
| Grants for root@%                                           |
+-------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION |
+-------------------------------------------------------------+
```

---

## 🐛 Troubleshooting

### ❌ Lỗi: "Access denied for user 'root'@'%'"

**Giải pháp:**
- Kiểm tra user và password đúng chưa
- Thử connect với user khác hoặc tạo user mới:
```sql
CREATE USER 'cinemax_user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON cinemax_db.* TO 'cinemax_user'@'%';
FLUSH PRIVILEGES;
```

### ❌ Lỗi: "Can't connect to MySQL server"

**Giải pháp:**
1. Kiểm tra MySQL đang chạy trên XAMPP
2. Kiểm tra `bind-address = 0.0.0.0` trong `my.ini`
3. Restart MySQL trong XAMPP
4. Test ping:
```bash
ping -c 3 $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
```

### ❌ Lỗi: "You need the SUPER privilege(s) for this operation"

**Giải pháp:**
- Connect với user có quyền SUPER (thường là root)
- Hoặc chạy từ MySQL trong Windows (không phải WSL)

---

## 📝 Quick Reference

### Grant quyền cho root (password rỗng):
```bash
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
mysql -h $WINDOWS_IP -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;"
```

### Grant quyền cho user mới:
```sql
CREATE USER 'cinemax_user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON cinemax_db.* TO 'cinemax_user'@'%';
FLUSH PRIVILEGES;
```

### Kiểm tra quyền:
```bash
mysql -h $WINDOWS_IP -u root -e "SHOW GRANTS FOR 'root'@'%';"
```

---

**💡 Tips:**
- Dùng script `grant-mysql-permissions.sh` để tự động hóa
- Lưu IP Windows host vào biến để dễ reuse
- Test connection trước khi grant quyền






