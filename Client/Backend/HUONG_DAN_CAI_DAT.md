# 🔧 Hướng Dẫn Cài Đặt và Chạy Backend

## ⚠️ Lỗi: Maven không được nhận diện

Nếu bạn gặp lỗi `mvn : The term 'mvn' is not recognized`, có 3 cách giải quyết:

---

## ✅ Cách 1: Sử dụng Maven Wrapper (Khuyến nghị - Không cần cài Maven)

Maven Wrapper đã được tạo sẵn. Chỉ cần chạy:

### Windows (PowerShell hoặc CMD):
```bash
cd Backend
.\mvnw.cmd spring-boot:run
```

### Nếu lần đầu chạy, Maven Wrapper sẽ tự động download Maven.

---

## ✅ Cách 2: Cài đặt Maven (Nếu muốn dùng `mvn` command)

### Bước 1: Download Maven
1. Truy cập: https://maven.apache.org/download.cgi
2. Download file: `apache-maven-3.9.5-bin.zip`
3. Giải nén vào thư mục: `C:\Program Files\Apache\maven`

### Bước 2: Thêm vào PATH
1. Mở **System Properties** → **Environment Variables**
2. Trong **System Variables**, tìm biến `Path` → Click **Edit**
3. Thêm: `C:\Program Files\Apache\maven\bin`
4. Click **OK** để lưu

### Bước 3: Kiểm tra
Mở PowerShell mới và chạy:
```bash
mvn --version
```

Nếu hiển thị version, bạn đã cài đặt thành công!

### Sau đó chạy:
```bash
cd Backend
mvn spring-boot:run
```

---

## ✅ Cách 3: Chạy bằng IDE (IntelliJ IDEA / Eclipse)

### Với IntelliJ IDEA:
1. Mở project: **File** → **Open** → Chọn thư mục `Backend`
2. IDE sẽ tự động nhận diện Maven project
3. Mở file `CineMaxApplication.java`
4. Click chuột phải → **Run 'CineMaxApplication'**

### Với Eclipse:
1. **File** → **Import** → **Existing Maven Projects**
2. Chọn thư mục `Backend`
3. Click **Finish**
4. Tìm `CineMaxApplication.java` → Click chuột phải → **Run As** → **Java Application**

---

## 📋 Checklist Trước Khi Chạy

### 1. Kiểm tra Java đã cài chưa:
```bash
java -version
```
Cần Java 17 trở lên.

### 2. Kiểm tra MySQL đã chạy chưa:
- Mở XAMPP Control Panel
- Start MySQL
- MySQL phải chạy trên port **3306**

### 3. Tạo Database:
```bash
mysql -u root -p < Backend/database/schema.sql
```

### 4. Cấu hình `application.properties`:
Sửa file: `Backend/src/main/resources/application.properties`
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/cinemax_db
spring.datasource.username=root
spring.datasource.password=  # Nhập password MySQL của bạn (nếu có)
```

---

## 🚀 Chạy Ứng Dụng

### Sau khi setup xong, chạy một trong các cách sau:

**Cách 1 (Maven Wrapper):**
```bash
cd Backend
.\mvnw.cmd spring-boot:run
```

**Cách 2 (Maven đã cài):**
```bash
cd Backend
mvn spring-boot:run
```

**Cách 3 (IDE):**
- IntelliJ IDEA: Run `CineMaxApplication.java`
- Eclipse: Run as Java Application

---

## ✅ Kiểm Tra

Sau khi chạy, bạn sẽ thấy:
```
Started CineMaxApplication in X.XXX seconds
```

Mở trình duyệt và truy cập:
- API: http://localhost:8080/api
- Test: http://localhost:8080/api/movies

---

## 🐛 Troubleshooting

### Lỗi: JAVA_HOME không tìm thấy
1. Tạo biến môi trường `JAVA_HOME` trỏ tới thư mục JDK
2. Thêm `%JAVA_HOME%\bin` vào PATH

### Lỗi: Port 8080 đã được sử dụng
Sửa trong `application.properties`:
```properties
server.port=8081
```

### Lỗi: Kết nối database thất bại
1. Kiểm tra MySQL đã chạy chưa
2. Kiểm tra username/password
3. Kiểm tra database `cinemax_db` đã tạo chưa

---

## 💡 Tips

- **Khuyến nghị**: Dùng Maven Wrapper (`mvnw.cmd`) vì không cần cài Maven
- Nếu dùng IDE, nên cài IntelliJ IDEA vì hỗ trợ Spring Boot tốt nhất
- Luôn chạy MySQL trước khi chạy backend

---

**Chúc bạn thành công! 🎉**


