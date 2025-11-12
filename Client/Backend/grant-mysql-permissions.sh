#!/bin/bash
# Script để grant quyền MySQL cho remote access từ WSL

echo "🔐 Grant MySQL Permissions - CineMax DB"
echo "========================================"
echo ""

# Lấy IP của Windows host
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

if [ -z "$WINDOWS_IP" ]; then
    echo "❌ Không thể lấy IP của Windows host!"
    exit 1
fi

echo "✅ Windows Host IP: $WINDOWS_IP"
echo ""

# Hỏi MySQL username
read -p "MySQL Username [root]: " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-root}

# Hỏi MySQL password
read -sp "MySQL Password (Enter nếu không có): " MYSQL_PASSWORD
echo ""

echo ""
echo "🔄 Đang grant quyền cho user '$MYSQL_USER'..."
echo ""

# SQL commands để grant quyền
SQL_COMMANDS="
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SELECT 'Permissions granted successfully!' AS status;
"

# Execute SQL commands
if [ -z "$MYSQL_PASSWORD" ]; then
    mysql -h "$WINDOWS_IP" -u "$MYSQL_USER" -e "$SQL_COMMANDS"
else
    mysql -h "$WINDOWS_IP" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "$SQL_COMMANDS"
fi

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ Grant quyền thành công!"
    echo ""
    echo "📊 Kiểm tra quyền:"
    echo "   mysql -h $WINDOWS_IP -u $MYSQL_USER -p -e \"SHOW GRANTS FOR '${MYSQL_USER}'@'%';\""
else
    echo ""
    echo "❌ Grant quyền thất bại! (Exit code: $EXIT_CODE)"
    echo ""
    echo "💡 Troubleshooting:"
    echo "   1. Kiểm tra MySQL đang chạy trên XAMPP"
    echo "   2. Kiểm tra bind-address trong my.ini đã set 0.0.0.0"
    echo "   3. Kiểm tra user và password đúng chưa"
    echo "   4. Test connection: mysql -h $WINDOWS_IP -u $MYSQL_USER -p"
    exit 1
fi






