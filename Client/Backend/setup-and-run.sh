#!/bin/bash
# Script setup và chạy dự án CineMax

echo "🚀 Setup và Run CineMax Project"
echo "================================"
echo ""

# Database Configuration
export DB_HOST=127.0.0.1
export DB_PORT=3306
export DB_DATABASE=cinemax_db
export DB_USERNAME=root
export DB_PASSWORD=

echo "📝 Database Configuration:"
echo "   Host: $DB_HOST"
echo "   Port: $DB_PORT"
echo "   Database: $DB_DATABASE"
echo "   Username: $DB_USERNAME"
echo "   Password: (empty)"
echo ""

# Nếu từ WSL, tự động lấy IP Windows host
if grep -qEi "(microsoft|WSL)" /proc/version &> /dev/null ; then
    WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
    if [ ! -z "$WINDOWS_IP" ] && [ "$WINDOWS_IP" != "127.0.0.1" ]; then
        echo "⚠️  Phát hiện WSL environment"
        echo "   Đang thay đổi DB_HOST từ 127.0.0.1 sang $WINDOWS_IP"
        export DB_HOST=$WINDOWS_IP
        echo "   New DB_HOST: $DB_HOST"
        echo ""
    fi
fi

# Test MySQL connection
echo "🔍 Testing MySQL connection..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" ${DB_PASSWORD:+-p"$DB_PASSWORD"} -e "SELECT 1;" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ Không thể kết nối MySQL!"
    echo ""
    echo "💡 Troubleshooting:"
    echo "   1. Kiểm tra MySQL đang chạy trên XAMPP"
    echo "   2. Nếu từ WSL, đảm bảo MySQL bind-address = 0.0.0.0 trong my.ini"
    echo "   3. Test connection: mysql -h $DB_HOST -u $DB_USERNAME -p"
    echo ""
    read -p "Bạn có muốn tiếp tục import database không? (y/n): " CONTINUE
    if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
        exit 1
    fi
else
    echo "✅ MySQL connection OK!"
    echo ""
fi

# Import database
echo "📦 Importing database schema..."
SCHEMA_FILE="database/schema.sql"

if [ ! -f "$SCHEMA_FILE" ]; then
    echo "❌ Không tìm thấy file: $SCHEMA_FILE"
    exit 1
fi

mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" ${DB_PASSWORD:+-p"$DB_PASSWORD"} < "$SCHEMA_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Import database thành công!"
    echo ""
else
    echo "⚠️  Import database có lỗi, nhưng có thể database đã tồn tại"
    echo ""
fi

# Verify database
echo "🔍 Verifying database..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" ${DB_PASSWORD:+-p"$DB_PASSWORD"} -e "USE $DB_DATABASE; SHOW TABLES;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Database $DB_DATABASE đã sẵn sàng!"
    echo ""
else
    echo "⚠️  Không thể verify database"
    echo ""
fi

# Run Spring Boot
echo "🚀 Starting Spring Boot application..."
echo ""
echo "📌 Environment variables:"
echo "   DB_HOST=$DB_HOST"
echo "   DB_PORT=$DB_PORT"
echo "   DB_DATABASE=$DB_DATABASE"
echo "   DB_USERNAME=$DB_USERNAME"
echo "   DB_PASSWORD=$DB_PASSWORD"
echo ""

mvn spring-boot:run





