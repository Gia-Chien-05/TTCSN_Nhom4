#!/bin/bash

echo "🖼️  Cập nhật Poster URLs cho Phim..."
echo ""

# Kiểm tra MySQL
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL chưa được cài đặt!"
    exit 1
fi

# Cập nhật poster URLs từ TMDB
echo "📝 Đang cập nhật poster URLs..."

mysql -u root -p cinemax_db <<EOF
-- Inception (tt1375666)
UPDATE movies 
SET poster_url = 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg' 
WHERE imdb_id = 'tt1375666';

-- Interstellar (tt0816692)
UPDATE movies 
SET poster_url = 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg' 
WHERE imdb_id = 'tt0816692';

-- The Matrix (tt0133093)
UPDATE movies 
SET poster_url = 'https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg' 
WHERE imdb_id = 'tt0133093';
EOF

if [ $? -eq 0 ]; then
    echo "✅ Poster URLs đã được cập nhật thành công!"
    echo ""
    echo "📋 Kiểm tra kết quả:"
    mysql -u root -p cinemax_db -e "SELECT id, title, poster_url FROM movies LIMIT 3;" 2>/dev/null || echo "Không thể kết nối database"
    echo ""
    echo "🔄 Refresh frontend để xem poster mới!"
else
    echo "❌ Có lỗi xảy ra khi cập nhật poster URLs"
    echo "   Kiểm tra MySQL đã chạy và database có tồn tại"
fi




