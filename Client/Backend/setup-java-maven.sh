#!/bin/bash
# Script tự động cài Java 17 và Maven

echo "📦 Setup Java và Maven cho CineMax Project"
echo "=========================================="
echo ""

# Kiểm tra Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    echo "✅ Java đã được cài: $JAVA_VERSION"
else
    echo "❌ Java chưa được cài đặt"
    echo ""
    echo "🔧 Đang cài Java 17..."
    sudo apt update
    sudo apt install openjdk-17-jdk -y
    
    if [ $? -eq 0 ]; then
        echo "✅ Java 17 đã được cài đặt!"
        java -version
    else
        echo "❌ Cài Java thất bại!"
        exit 1
    fi
fi

echo ""
echo ""

# Kiểm tra Maven
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn -version | head -1)
    echo "✅ Maven đã được cài: $MVN_VERSION"
else
    echo "❌ Maven chưa được cài đặt"
    echo ""
    echo "🔧 Đang cài Maven..."
    sudo apt install maven -y
    
    if [ $? -eq 0 ]; then
        echo "✅ Maven đã được cài đặt!"
        mvn -version
    else
        echo "❌ Cài Maven thất bại!"
        exit 1
    fi
fi

echo ""
echo "✅ Setup hoàn tất!"
echo ""
echo "📝 Kiểm tra:"
echo "   java -version"
echo "   mvn -version"
echo ""
echo "🚀 Bây giờ bạn có thể chạy:"
echo "   ./run-simple.sh"





