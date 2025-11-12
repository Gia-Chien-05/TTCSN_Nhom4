#!/bin/bash
# Chạy Spring Boot với config cố định
export DB_HOST=127.0.0.1
export DB_PORT=3306
export DB_DATABASE=cinemax_db
export DB_USERNAME=root
export DB_PASSWORD=


echo "🚀 Starting CineMax API..."
echo "DB_HOST=$DB_HOST | DB_PORT=$DB_PORT | DB_DATABASE=$DB_DATABASE"
echo ""

# Kiểm tra Maven
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven chưa được cài đặt!"
    echo ""
    echo "💡 Cài Maven bằng lệnh:"
    echo "   sudo apt update && sudo apt install maven -y"
    echo ""
    echo "Hoặc xem hướng dẫn: cat SETUP_MAVEN.md"
    exit 1
fi

mvn spring-boot:run
