#!/usr/bin/env python3
# Script Python để tạo ghế cho phòng chiếu

import mysql.connector
import sys

# Database config
DB_CONFIG = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'cinemax_db'
}

try:
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    print("=== Tạo Ghế cho Phòng Chiếu ===")
    print()
    
    # Phòng 1: IMAX 1 - 15 hàng x 20 ghế = 300 ghế
    print("Đang tạo ghế cho Phòng 1: IMAX 1...")
    rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O']
    for row in rows:
        seat_type = 'VIP' if row in ['A', 'B'] else 'NORMAL'
        for seat_num in range(1, 21):
            try:
                cursor.execute("""
                    INSERT INTO seats (room_id, `row_number`, seat_number, seat_type, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, NOW(), NOW())
                """, (1, row, seat_num, seat_type))
            except mysql.connector.IntegrityError:
                pass  # Ghế đã tồn tại
    
    # Phòng 2: Standard 1 - 10 hàng x 20 ghế = 200 ghế
    print("Đang tạo ghế cho Phòng 2: Standard 1...")
    rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
    for row in rows:
        seat_type = 'VIP' if row == 'A' else 'NORMAL'
        for seat_num in range(1, 21):
            try:
                cursor.execute("""
                    INSERT INTO seats (room_id, `row_number`, seat_number, seat_type, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, NOW(), NOW())
                """, (2, row, seat_num, seat_type))
            except mysql.connector.IntegrityError:
                pass
    
    # Phòng 3: Lotte 1 - 12 hàng x 21 ghế = 252 ghế
    print("Đang tạo ghế cho Phòng 3: Lotte 1...")
    rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L']
    for row in rows:
        seat_type = 'VIP' if row in ['A', 'B', 'C'] else 'NORMAL'
        for seat_num in range(1, 22):
            try:
                cursor.execute("""
                    INSERT INTO seats (room_id, `row_number`, seat_number, seat_type, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, NOW(), NOW())
                """, (3, row, seat_num, seat_type))
            except mysql.connector.IntegrityError:
                pass
    
    # Phòng 4: Starium 1 - 18 hàng x 20 ghế = 360 ghế
    print("Đang tạo ghế cho Phòng 4: Starium 1...")
    rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R']
    for row in rows:
        seat_type = 'VIP' if row in ['A', 'B', 'C'] else 'NORMAL'
        for seat_num in range(1, 21):
            try:
                cursor.execute("""
                    INSERT INTO seats (room_id, `row_number`, seat_number, seat_type, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, NOW(), NOW())
                """, (4, row, seat_num, seat_type))
            except mysql.connector.IntegrityError:
                pass
    
    conn.commit()
    
    # Kiểm tra kết quả
    print()
    print("=== Kết quả ===")
    cursor.execute("""
        SELECT 
            r.id as room_id,
            r.room_name,
            c.name as cinema_name,
            COUNT(s.id) as total_seats,
            COUNT(CASE WHEN s.seat_type = 'VIP' THEN 1 END) as vip_seats,
            COUNT(CASE WHEN s.seat_type = 'NORMAL' THEN 1 END) as normal_seats
        FROM cinema_rooms r
        JOIN cinemas c ON r.cinema_id = c.id
        LEFT JOIN seats s ON r.id = s.room_id
        GROUP BY r.id, r.room_name, c.name
        ORDER BY r.id
    """)
    
    print(f"{'Room ID':<10} {'Room Name':<20} {'Cinema':<25} {'Total':<10} {'VIP':<10} {'Normal':<10}")
    print("-" * 90)
    for row in cursor.fetchall():
        print(f"{row[0]:<10} {row[1]:<20} {row[2]:<25} {row[3]:<10} {row[4]:<10} {row[5]:<10}")
    
    print()
    print("=== Ví dụ ghế (Phòng 1) ===")
    cursor.execute("""
        SELECT id, `row_number`, seat_number, seat_type 
        FROM seats 
        WHERE room_id = 1 
        ORDER BY `row_number`, seat_number 
        LIMIT 30
    """)
    
    print(f"{'ID':<10} {'Row':<5} {'Seat':<10} {'Type':<10}")
    print("-" * 35)
    for row in cursor.fetchall():
        print(f"{row[0]:<10} {row[1]:<5} {row[2]:<10} {row[3]:<10}")
    
    cursor.close()
    conn.close()
    
    print()
    print("✅ Hoàn tất!")
    
except mysql.connector.Error as err:
    print(f"❌ Lỗi: {err}")
    sys.exit(1)
except Exception as e:
    print(f"❌ Lỗi: {e}")
    sys.exit(1)



