#!/bin/bash
# Script để import database schema từ WSL đến MySQL trên Windows XAMPP

echo "🔧 Import Database Schema - CineMax DB"
echo "========================================"
echo ""

# Lấy IP của Windows host
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

if [ -z "$WINDOWS_IP" ]; then
    echo "❌ Không thể lấy IP của Windows host!"
    echo "   Hãy thử lấy thủ công: ip route show | grep -i default | awk '{ print \$3}'"
    exit 1
fi

echo "✅ Windows Host IP: $WINDOWS_IP"
echo ""

# Kiểm tra file schema.sql có tồn tại không
SCHEMA_FILE="database/schema.sql"

if [ ! -f "$SCHEMA_FILE" ]; then
    echo "❌ Không tìm thấy file: $SCHEMA_FILE"
    exit 1
fi

echo "📄 File schema: $SCHEMA_FILE"
echo ""

# Hỏi MySQL username
read -p "MySQL Username [root]: " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-root}

# Hỏi MySQL password
read -sp "MySQL Password (Enter nếu không có): " MYSQL_PASSWORD
echo ""

echo ""
echo "🔄 Đang import database..."
echo ""

# Import database
if [ -z "$MYSQL_PASSWORD" ]; then
    mysql -h "$WINDOWS_IP" -u "$MYSQL_USER" < "$SCHEMA_FILE"
else
    mysql -h "$WINDOWS_IP" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" < "$SCHEMA_FILE"
fi

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ Import database thành công!"
    echo ""
    echo "📊 Kiểm tra database:"
    echo "   mysql -h $WINDOWS_IP -u $MYSQL_USER -p -e 'USE cinemax_db; SHOW TABLES;'"
else
    echo ""
    echo "❌ Import database thất bại! (Exit code: $EXIT_CODE)"
    echo ""
    echo "💡 Troubleshooting:"
    echo "   1. Kiểm tra MySQL đang chạy trên XAMPP"
    echo "   2. Kiểm tra bind-address trong my.ini đã set 0.0.0.0"
    echo "   3. Kiểm tra user có quyền tạo database"
    echo "   4. Test connection: mysql -h $WINDOWS_IP -u $MYSQL_USER -p"
    exit 1
fi






