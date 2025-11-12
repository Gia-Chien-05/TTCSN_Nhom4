#!/bin/bash
# Script chạy Spring Boot với config database

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

echo "🚀 Starting CineMax API..."
echo "   DB_HOST=$DB_HOST"
echo "   DB_PORT=$DB_PORT"
echo "   DB_DATABASE=$DB_DATABASE"
echo "   DB_USERNAME=$DB_USERNAME"
echo ""

mvn spring-boot:run





