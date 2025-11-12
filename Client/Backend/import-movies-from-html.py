#!/usr/bin/env python3
"""
Script để import phim từ OMDb API vào database
Lấy danh sách IMDb ID từ file HTML và thêm vào database
"""

import requests
import mysql.connector
from mysql.connector import Error
import os
import sys
import time
from datetime import datetime
from decimal import Decimal

# Cấu hình database
DB_HOST = os.getenv('DB_HOST', '127.0.0.1')
DB_PORT = int(os.getenv('DB_PORT', 3306))
DB_DATABASE = os.getenv('DB_DATABASE', 'cinemax_db')
DB_USERNAME = os.getenv('DB_USERNAME', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD', '')

# OMDb API Key
OMDB_API_KEY = 'fa85c569'
OMDB_BASE_URL = 'https://www.omdbapi.com/'

# Danh sách IMDb ID từ file Phim.html và XemLichChieu.html
IMDB_IDS = [
    'tt0111161',  # The Shawshank Redemption
    'tt0468569',  # The Dark Knight
    'tt0109830',  # Forrest Gump
    'tt0167260',  # The Lord of the Rings: The Return of the King
    'tt0137523',  # Fight Club
    'tt0110912',  # Pulp Fiction
    'tt0120737',  # The Lord of the Rings: The Fellowship of the Ring
    'tt3896198',  # Guardians of the Galaxy Vol. 2
    'tt4154796',  # Avengers: Endgame
    'tt4154756',  # Avengers: Infinity War
]

# Mapping tên phim tiếng Việt (nếu có)
VIETNAMESE_TITLES = {
    'tt0111161': 'Nhà Tù Shawshank',
    'tt0468569': 'Kỵ Sĩ Bóng Đêm',
    'tt0109830': 'Forrest Gump',
    'tt0167260': 'Chúa Tể Những Chiếc Nhẫn: Sự Trở Lại Của Nhà Vua',
    'tt0137523': 'Câu Lạc Bộ Đấu Sĩ',
    'tt0110912': 'Pulp Fiction',
    'tt0120737': 'Chúa Tể Những Chiếc Nhẫn: Hiệp Hội Nhẫn Thần',
    'tt3896198': 'Vệ Binh Dải Ngân Hà 2',
    'tt4154796': 'Biệt Đội Siêu Anh Hùng: Hồi Kết',
    'tt4154756': 'Biệt Đội Siêu Anh Hùng: Cuộc Chiến Vô Cực',
}

def parse_duration(runtime_str):
    """Parse duration từ string như '148 min' thành minutes (int)"""
    if not runtime_str or runtime_str == 'N/A':
        return None
    try:
        # Extract number from string like "148 min"
        minutes = int(runtime_str.replace(' min', '').strip())
        return minutes
    except:
        return None

def parse_rating(rating_str):
    """Parse rating từ string như '8.8/10' thành Decimal"""
    if not rating_str or rating_str == 'N/A':
        return None
    try:
        # Extract number from string like "8.8/10"
        rating = rating_str.split('/')[0].strip()
        return Decimal(rating)
    except:
        return None

def parse_release_date(date_str):
    """Parse release date từ string như '16 Jul 2010' thành YYYY-MM-DD"""
    if not date_str or date_str == 'N/A':
        return None
    try:
        # Try different date formats
        formats = ['%d %b %Y', '%Y-%m-%d', '%d %B %Y']
        for fmt in formats:
            try:
                date = datetime.strptime(date_str, fmt)
                return date.strftime('%Y-%m-%d')
            except:
                continue
        return None
    except:
        return None

def fetch_movie_from_omdb(imdb_id):
    """Fetch movie data from OMDb API"""
    url = f"{OMDB_BASE_URL}?i={imdb_id}&apikey={OMDB_API_KEY}&plot=full"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        if data.get('Response') == 'False':
            print(f"❌ Error for {imdb_id}: {data.get('Error', 'Unknown error')}")
            return None
            
        return data
    except Exception as e:
        print(f"❌ Error fetching {imdb_id}: {str(e)}")
        return None

def get_db_connection():
    """Tạo connection đến MySQL database"""
    try:
        connection = mysql.connector.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_DATABASE,
            user=DB_USERNAME,
            password=DB_PASSWORD
        )
        return connection
    except Error as e:
        print(f"❌ Error connecting to database: {e}")
        return None

def check_movie_exists(cursor, imdb_id):
    """Kiểm tra xem phim đã tồn tại trong database chưa"""
    cursor.execute("SELECT id FROM movies WHERE imdb_id = %s", (imdb_id,))
    result = cursor.fetchone()
    return result is not None

def insert_movie(cursor, movie_data):
    """Insert movie vào database"""
    imdb_id = movie_data.get('imdbID')
    
    # Check if movie already exists
    if check_movie_exists(cursor, imdb_id):
        print(f"⏭️  Movie {imdb_id} ({movie_data.get('Title')}) already exists, skipping...")
        return False
    
    # Parse data
    title = movie_data.get('Title', 'Unknown')
    title_vietnamese = VIETNAMESE_TITLES.get(imdb_id)
    description = movie_data.get('Plot', movie_data.get('Plot', 'N/A'))
    if description == 'N/A':
        description = None
    
    genre = movie_data.get('Genre', 'N/A')
    if genre == 'N/A':
        genre = None
    
    director = movie_data.get('Director', 'N/A')
    if director == 'N/A':
        director = None
    
    actors = movie_data.get('Actors', 'N/A')
    if actors == 'N/A':
        actors = None
    
    release_date = parse_release_date(movie_data.get('Released', 'N/A'))
    duration = parse_duration(movie_data.get('Runtime', 'N/A'))
    rating = parse_rating(movie_data.get('imdbRating', 'N/A'))
    
    language = movie_data.get('Language', 'N/A')
    if language == 'N/A':
        language = None
    else:
        # Take first language
        language = language.split(',')[0].strip() if language else None
    
    country = movie_data.get('Country', 'N/A')
    if country == 'N/A':
        country = None
    else:
        # Take first country
        country = country.split(',')[0].strip() if country else None
    
    poster_url = movie_data.get('Poster', 'N/A')
    if poster_url == 'N/A' or not poster_url:
        poster_url = None
    
    # Default price (có thể điều chỉnh)
    price = Decimal('85000.00')
    vip_price = Decimal('120000.00')
    
    # Status - mặc định là NOW_SHOWING
    status = 'NOW_SHOWING'
    
    # Insert query
    insert_query = """
    INSERT INTO movies (
        imdb_id, title, title_vietnamese, description, genre, director, actors,
        release_date, duration, rating, language, country, poster_url, trailer_url,
        status, price, vip_price, created_at, updated_at
    ) VALUES (
        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW()
    )
    """
    
    try:
        cursor.execute(insert_query, (
            imdb_id, title, title_vietnamese, description, genre, director, actors,
            release_date, duration, rating, language, country, poster_url, None,
            status, price, vip_price
        ))
        print(f"✅ Inserted: {title} ({imdb_id})")
        return True
    except Error as e:
        print(f"❌ Error inserting {title}: {e}")
        return False

def main():
    print("🚀 Starting movie import from OMDb API...")
    print(f"📋 Database: {DB_HOST}:{DB_PORT}/{DB_DATABASE}")
    print(f"📋 Total movies to import: {len(IMDB_IDS)}")
    print("=" * 60)
    
    # Connect to database
    connection = get_db_connection()
    if not connection:
        print("❌ Cannot connect to database. Exiting...")
        sys.exit(1)
    
    cursor = connection.cursor()
    
    success_count = 0
    skip_count = 0
    error_count = 0
    
    # Process each IMDb ID
    for i, imdb_id in enumerate(IMDB_IDS, 1):
        print(f"\n[{i}/{len(IMDB_IDS)}] Processing {imdb_id}...")
        
        # Check if already exists
        if check_movie_exists(cursor, imdb_id):
            print(f"⏭️  Movie {imdb_id} already exists, skipping...")
            skip_count += 1
            continue
        
        # Fetch from OMDb API
        movie_data = fetch_movie_from_omdb(imdb_id)
        if not movie_data:
            error_count += 1
            continue
        
        # Insert into database
        if insert_movie(cursor, movie_data):
            success_count += 1
            connection.commit()
        else:
            error_count += 1
        
        # Rate limiting - wait a bit between requests
        time.sleep(1)
    
    # Close connection
    cursor.close()
    connection.close()
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 Import Summary:")
    print(f"   ✅ Success: {success_count}")
    print(f"   ⏭️  Skipped: {skip_count}")
    print(f"   ❌ Errors: {error_count}")
    print(f"   📋 Total: {len(IMDB_IDS)}")
    print("=" * 60)

if __name__ == "__main__":
    main()


