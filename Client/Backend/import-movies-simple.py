#!/usr/bin/env python3
"""
Simple script to import movies from OMDb API to MySQL database
Uses only built-in Python modules (json, urllib) and mysql command line
"""

import json
import urllib.request
import urllib.parse
import subprocess
import os
import sys
from datetime import datetime

# Database config
DB_HOST = os.getenv('DB_HOST', '127.0.0.1')
DB_PORT = os.getenv('DB_PORT', '3306')
DB_DATABASE = os.getenv('DB_DATABASE', 'cinemax_db')
DB_USERNAME = os.getenv('DB_USERNAME', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD', '')

# OMDb API
OMDB_API_KEY = 'fa85c569'
OMDB_BASE_URL = 'https://www.omdbapi.com/'

# IMDb IDs to import
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

# Vietnamese titles
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

def escape_sql(s):
    """Escape SQL string"""
    if s is None:
        return 'NULL'
    return "'" + str(s).replace("'", "''") + "'"

def parse_duration(runtime):
    """Parse duration from '148 min' to 148"""
    if not runtime or runtime == 'N/A':
        return None
    try:
        return int(runtime.replace(' min', '').strip())
    except:
        return None

def parse_rating(rating):
    """Parse rating from '8.8/10' to 8.8"""
    if not rating or rating == 'N/A':
        return None
    try:
        return float(rating.split('/')[0].strip())
    except:
        return None

def parse_date(date_str):
    """Parse date from various formats"""
    if not date_str or date_str == 'N/A':
        return None
    try:
        # Try common formats
        formats = ['%d %b %Y', '%d %B %Y', '%Y-%m-%d']
        for fmt in formats:
            try:
                dt = datetime.strptime(date_str, fmt)
                return dt.strftime('%Y-%m-%d')
            except:
                continue
        return None
    except:
        return None

def get_first_item(s):
    """Get first item from comma-separated string"""
    if not s or s == 'N/A':
        return None
    return s.split(',')[0].strip()

def fetch_movie(imdb_id):
    """Fetch movie from OMDb API"""
    url = f"{OMDB_BASE_URL}?i={imdb_id}&apikey={OMDB_API_KEY}&plot=full"
    try:
        with urllib.request.urlopen(url, timeout=10) as response:
            data = json.loads(response.read().decode())
            if data.get('Response') == 'False':
                print(f"❌ Error: {data.get('Error', 'Unknown error')}")
                return None
            return data
    except Exception as e:
        print(f"❌ Error fetching {imdb_id}: {e}")
        return None

def check_exists(imdb_id):
    """Check if movie exists in database"""
    cmd = [
        'mysql',
        '-h', DB_HOST,
        '-P', DB_PORT,
        '-u', DB_USERNAME,
        DB_DATABASE,
        '-s', '-N',
        '-e', f"SELECT id FROM movies WHERE imdb_id = '{imdb_id}';"
    ]
    if DB_PASSWORD:
        cmd.insert(5, f"-p{DB_PASSWORD}")
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
        return result.returncode == 0 and result.stdout.strip()
    except:
        return False

def insert_movie(movie_data):
    """Insert movie into database using mysql command"""
    imdb_id = movie_data.get('imdbID')
    
    # Parse data
    title = movie_data.get('Title', 'Unknown')
    title_vn = VIETNAMESE_TITLES.get(imdb_id)
    description = movie_data.get('Plot')
    if description == 'N/A':
        description = None
    
    genre = movie_data.get('Genre')
    if genre == 'N/A':
        genre = None
    
    director = movie_data.get('Director')
    if director == 'N/A':
        director = None
    
    actors = movie_data.get('Actors')
    if actors == 'N/A':
        actors = None
    
    released = parse_date(movie_data.get('Released'))
    duration = parse_duration(movie_data.get('Runtime'))
    rating = parse_rating(movie_data.get('imdbRating'))
    language = get_first_item(movie_data.get('Language'))
    country = get_first_item(movie_data.get('Country'))
    poster = movie_data.get('Poster')
    if poster == 'N/A' or not poster:
        poster = None
    
    # Default prices
    price = 85000.00
    vip_price = 120000.00
    status = 'NOW_SHOWING'
    
    # Build SQL
    sql = f"""INSERT INTO movies (
        imdb_id, title, title_vietnamese, description, genre, director, actors,
        release_date, duration, rating, language, country, poster_url, trailer_url,
        status, price, vip_price, created_at, updated_at
    ) VALUES (
        {escape_sql(imdb_id)},
        {escape_sql(title)},
        {escape_sql(title_vn) if title_vn else 'NULL'},
        {escape_sql(description) if description else 'NULL'},
        {escape_sql(genre) if genre else 'NULL'},
        {escape_sql(director) if director else 'NULL'},
        {escape_sql(actors) if actors else 'NULL'},
        {escape_sql(released) if released else 'NULL'},
        {duration if duration else 'NULL'},
        {rating if rating else 'NULL'},
        {escape_sql(language) if language else 'NULL'},
        {escape_sql(country) if country else 'NULL'},
        {escape_sql(poster) if poster else 'NULL'},
        NULL,
        {escape_sql(status)},
        {price},
        {vip_price},
        NOW(),
        NOW()
    );"""
    
    # Execute SQL
    cmd = ['mysql', '-h', DB_HOST, '-P', DB_PORT, '-u', DB_USERNAME, DB_DATABASE]
    if DB_PASSWORD:
        cmd.insert(5, f"-p{DB_PASSWORD}")
    
    try:
        result = subprocess.run(cmd, input=sql, capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            print(f"✅ Inserted: {title} ({imdb_id})")
            return True
        else:
            print(f"❌ Error: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ Error executing SQL: {e}")
        return False

def main():
    print("🚀 Starting movie import from OMDb API...")
    print(f"📋 Database: {DB_HOST}:{DB_PORT}/{DB_DATABASE}")
    print(f"📋 Total movies: {len(IMDB_IDS)}")
    print("=" * 60)
    
    success = 0
    skipped = 0
    errors = 0
    
    for i, imdb_id in enumerate(IMDB_IDS, 1):
        print(f"\n[{i}/{len(IMDB_IDS)}] Processing {imdb_id}...")
        
        # Check if exists
        if check_exists(imdb_id):
            print(f"⏭️  Already exists, skipping...")
            skipped += 1
            continue
        
        # Fetch from API
        movie_data = fetch_movie(imdb_id)
        if not movie_data:
            errors += 1
            continue
        
        # Insert
        if insert_movie(movie_data):
            success += 1
        else:
            errors += 1
        
        # Rate limiting
        import time
        time.sleep(1)
    
    print("\n" + "=" * 60)
    print("📊 Summary:")
    print(f"   ✅ Success: {success}")
    print(f"   ⏭️  Skipped: {skipped}")
    print(f"   ❌ Errors: {errors}")
    print("=" * 60)

if __name__ == "__main__":
    main()


