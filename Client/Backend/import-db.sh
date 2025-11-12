#!/bin/bash
# Script import database đơn giản

export DB_HOST=127.0.0.1
export DB_PORT=3306
export DB_DATABASE=cinemax_db
export DB_USERNAME=root
export DB_PASSWORD=

# Nếu từ WSL, tự động lấy IP Windows host
if grep -qEi "(microsoft|WSL)" /proc/version &> /dev/null ; then
    WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
    if [ ! -z "$WINDOWS_IP" ] && [ "$WINDOWS_IP" != "127.0.0.1" ]; then
        export DB_HOST=$WINDOWS_IP
    fi
fi

echo "📦 Importing database..."
echo "   Host: $DB_HOST"
echo "   Database: $DB_DATABASE"
echo ""

mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" ${DB_PASSWORD:+-p"$DB_PASSWORD"} < database/schema.sql

if [ $? -eq 0 ]; then
    echo "✅ Import thành công!"
else
    echo "❌ Import thất bại!"
    exit 1
fi





