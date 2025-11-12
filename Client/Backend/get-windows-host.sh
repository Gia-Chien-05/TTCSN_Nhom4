#!/bin/bash
# Script để lấy IP của Windows host từ WSL

# Cách 1: Lấy từ /etc/resolv.conf (thường dùng cho WSL2)
WINDOWS_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Cách 2: Nếu không có, thử lấy từ route
if [ -z "$WINDOWS_HOST" ] || [ "$WINDOWS_HOST" == "127.0.0.1" ]; then
    WINDOWS_HOST=$(ip route show | grep -i default | awk '{ print $3}')
fi

# Cách 3: Thử ping host.docker.internal (nếu có)
if [ -z "$WINDOWS_HOST" ]; then
    WINDOWS_HOST="host.docker.internal"
fi

echo "Windows Host IP: $WINDOWS_HOST"
echo ""
echo "Để test connection, chạy lệnh:"
echo "mysql -h $WINDOWS_HOST -u root -p"
echo ""
echo "Hoặc test ping:"
echo "ping -c 3 $WINDOWS_HOST"






