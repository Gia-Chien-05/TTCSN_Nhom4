# 🚀 Hướng Dẫn Setup Đầy Đủ - CineMax Project

## ⚡ Quick Setup (Tự Động)

Chạy script tự động để cài Java và Maven:

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
chmod +x setup-java-maven.sh
./setup-java-maven.sh
```

## 📋 Setup Thủ Công (Từng Bước)

### 1. Cài Java 17

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
```

Verify:
```bash
java -version
```

### 2. Cài Maven

```bash
sudo apt install maven -y
```

Verify:
```bash
mvn -version
```

### 3. Setup Database

```bash
# Import database
./import-db-simple.sh

# Hoặc xóa và import lại
./drop-and-import.sh
```

### 4. Chạy Dự Án

```bash
./run-simple.sh
```

## ✅ Checklist

- [ ] Java 17 đã được cài (`java -version`)
- [ ] Maven đã được cài (`mvn -version`)
- [ ] MySQL đang chạy trên XAMPP
- [ ] Database đã được import (`cinemax_db`)
- [ ] Config database trong `application.properties` đúng
- [ ] Chạy được Spring Boot application

## 🐛 Troubleshooting

### ❌ "java: command not found"

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
```

### ❌ "mvn: command not found"

```bash
sudo apt install maven -y
```

### ❌ "Can't connect to MySQL"

1. Kiểm tra MySQL đang chạy trong XAMPP
2. Nếu từ WSL, config `bind-address = 0.0.0.0` trong `my.ini`
3. Test connection: `mysql -h 127.0.0.1 -u root -p`

### ❌ "Database not found"

```bash
./import-db-simple.sh
```

## 📝 Quick Commands

```bash
# Cài Java + Maven
sudo apt update && sudo apt install openjdk-17-jdk maven -y

# Import database
./import-db-simple.sh

# Chạy dự án
./run-simple.sh
```

## 🎯 Sau Khi Setup

API sẽ chạy tại: `http://localhost:8080/api`

Kiểm tra logs để đảm bảo connection database thành công:
```
HikariPool-1 - Starting...
HikariPool-1 - Start completed.
```





