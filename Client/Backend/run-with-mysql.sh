#!/bin/bash
# Script để chạy Spring Boot với MySQL connection tự động lấy IP Windows host

echo "🚀 Starting CineMax API với MySQL connection..."
echo "================================================"
echo ""

# Lấy IP của Windows host
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

if [ -z "$WINDOWS_IP" ]; then
    echo "❌ Không thể lấy IP của Windows host!"
    WINDOWS_IP="localhost"
    echo "⚠️  Sử dụng localhost (có thể không hoạt động)"
else
    echo "✅ Windows Host IP: $WINDOWS_IP"
fi

echo ""
echo "📝 Config MySQL connection:"
echo "   Host: $WINDOWS_IP"
echo "   Database: cinemax_db"
echo "   Username: root"
echo ""

# Export environment variables
export MYSQL_HOST=$WINDOWS_IP
export MYSQL_USER=root
export MYSQL_PASSWORD=""

echo "🔄 Starting Spring Boot application..."
echo ""

# Chạy Spring Boot với Maven
mvn spring-boot:run






