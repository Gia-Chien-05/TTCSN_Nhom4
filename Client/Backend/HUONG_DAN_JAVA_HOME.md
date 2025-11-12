# 🔧 Hướng Dẫn Cấu Hình JAVA_HOME

## ⚠️ Lỗi: JAVA_HOME not found

Lỗi này xảy ra khi chưa cấu hình biến môi trường `JAVA_HOME` hoặc chưa cài Java.

---

## ✅ Bước 1: Kiểm Tra Java Đã Cài Chưa

Mở PowerShell và chạy:
```powershell
java -version
```

### Nếu hiển thị version (vd: `java version "17.0.x"`):
- ✅ Java đã được cài
- Chuyển sang **Bước 2** để thiết lập JAVA_HOME

### Nếu hiển thị lỗi (`'java' is not recognized`):
- ❌ Java chưa được cài
- Cần cài **JDK 17** trước (xem **Phần A**)

---

## 📦 Phần A: Cài Đặt JDK 17

### Cách 1: Tải JDK từ Oracle (Khuyến nghị)

1. **Download JDK 17:**
   - Truy cập: https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html
   - Hoặc: https://adoptium.net/ (OpenJDK - miễn phí)
   - Chọn **Windows x64 Installer**

2. **Cài đặt:**
   - Chạy file installer
   - Chọn đường dẫn mặc định: `C:\Program Files\Java\jdk-17`
   - Click **Next** → **Install**

3. **Kiểm tra:**
   ```powershell
   java -version
   ```
   Phải hiển thị version 17.x

### Cách 2: Cài bằng Chocolatey (Nếu có)

```powershell
choco install openjdk17
```

---

## 🔧 Bước 2: Thiết Lập JAVA_HOME

### Cách 1: Qua System Properties (GUI - Dễ nhất)

1. **Mở System Properties:**
   - Nhấn `Win + R` → Gõ `sysdm.cpl` → Enter
   - Hoặc: Click chuột phải **This PC** → **Properties** → **Advanced system settings**

2. **Thêm JAVA_HOME:**
   - Click tab **Advanced** → Click **Environment Variables**

3. **Tạo biến JAVA_HOME:**
   - Phần **System variables** → Click **New...**
   - **Variable name:** `JAVA_HOME`
   - **Variable value:** `C:\Program Files\Java\jdk-17` 
     *(Hoặc đường dẫn nơi bạn cài JDK)*
   - Click **OK**

4. **Thêm Java vào PATH:**
   - Tìm biến **Path** trong **System variables**
   - Click **Edit...**
   - Click **New** → Thêm: `%JAVA_HOME%\bin`
   - Click **OK** → **OK** → **OK**

5. **Kiểm tra:**
   - **Mở PowerShell MỚI** (phải đóng và mở lại)
   - Chạy:
     ```powershell
     echo $env:JAVA_HOME
     java -version
     ```

### Cách 2: Qua PowerShell (Nhanh - Nhưng tạm thời)

Chạy trong PowerShell với quyền Admin:
```powershell
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-17", "Machine")
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";%JAVA_HOME%\bin", "Machine")
```

⚠️ **Lưu ý:** Thay `C:\Program Files\Java\jdk-17` bằng đường dẫn JDK thực tế của bạn.

Sau đó **mở PowerShell mới** và kiểm tra:
```powershell
echo $env:JAVA_HOME
```

---

## 🔍 Bước 3: Tìm Đường Dẫn JDK

Nếu không biết JDK cài ở đâu, chạy:

```powershell
Get-ChildItem "C:\Program Files\Java\" -Directory
```

Hoặc:
```powershell
where.exe java
```

Kết quả sẽ là: `C:\Program Files\Java\jdk-17\bin\java.exe`

Vậy JAVA_HOME sẽ là: `C:\Program Files\Java\jdk-17`

---

## ✅ Bước 4: Kiểm Tra Lại

Sau khi thiết lập xong, **mở PowerShell MỚI** và chạy:

```powershell
# Kiểm tra JAVA_HOME
echo $env:JAVA_HOME

# Kiểm tra Java version
java -version

# Kiểm tra javac (compiler)
javac -version
```

Nếu tất cả đều OK, chạy:
```powershell
cd Backend
.\mvnw.cmd spring-boot:run
```

---

## 🐛 Troubleshooting

### Vẫn lỗi JAVA_HOME sau khi cấu hình?

1. **Đóng và mở lại PowerShell** (biến môi trường chỉ load khi mở terminal mới)
2. **Kiểm tra lại đường dẫn:**
   ```powershell
   Test-Path "C:\Program Files\Java\jdk-17"
   ```
   Nếu `False`, tìm lại đường dẫn thực tế
3. **Khởi động lại máy** nếu vẫn không được

### Lỗi: Java version không đúng

Cần JDK 17 trở lên. Kiểm tra:
```powershell
java -version
```

Nếu version thấp hơn 17, cần cài JDK 17 và cập nhật JAVA_HOME.

---

## 📝 Tóm Tắt Nhanh

1. ✅ Cài JDK 17 (nếu chưa có)
2. ✅ Thiết lập JAVA_HOME = đường dẫn JDK
3. ✅ Thêm %JAVA_HOME%\bin vào PATH
4. ✅ Đóng và mở lại PowerShell
5. ✅ Chạy `.\mvnw.cmd spring-boot:run`

---

**Chúc bạn thành công! 🎉**


