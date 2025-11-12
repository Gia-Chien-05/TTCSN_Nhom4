# 📦 Hướng Dẫn Cài Đặt Maven

## ⚡ Cài Maven trên WSL/Ubuntu

### Cách 1: Cài bằng apt (Khuyên dùng)

```bash
sudo apt update
sudo apt install maven -y
```

### Cách 2: Cài bằng SDKMAN (Nếu cần version cụ thể)

```bash
# Cài SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Cài Maven
sdk install maven
```

### Cách 3: Cài thủ công

```bash
# Tải Maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz

# Giải nén
tar -xzf apache-maven-3.9.5-bin.tar.gz
sudo mv apache-maven-3.9.5 /opt/maven

# Thêm vào PATH
echo 'export PATH=/opt/maven/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## ✅ Verify Maven

Sau khi cài, kiểm tra:

```bash
mvn -version
```

Kết quả mong đợi:
```
Apache Maven 3.9.x
Maven home: /usr/share/maven
Java version: 17.x.x
```

## 🚀 Sau khi cài Maven

Chạy lại script:

```bash
cd /var/www/TTCSN_Website-ban-ve-xem-phim/Backend
./run-simple.sh
```

## 📝 Quick Command

```bash
sudo apt update && sudo apt install maven -y && mvn -version
```





