#!/usr/bin/env python3
"""
Script để cập nhật poster URL cho các phim đã có trong database nhưng chưa có poster
"""

import json
import urllib.request
import urllib.parse
import subprocess
import os
import sys
import time

# Database config
DB_HOST = os.getenv('DB_HOST', '127.0.0.1')
DB_PORT = os.getenv('DB_PORT', '3306')
DB_DATABASE = os.getenv('DB_DATABASE', 'cinemax_db')
DB_USERNAME = os.getenv('DB_USERNAME', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD', '')

# OMDb API
OMDB_API_KEY = 'fa85c569'
OMDB_BASE_URL = 'https://www.omdbapi.com/'

def escape_sql(s):
    """Escape SQL string"""
    if s is None:
        return 'NULL'
    return "'" + str(s).replace("'", "''") + "'"

def fetch_movie(imdb_id):
    """Fetch movie from OMDb API"""
    url = f"{OMDB_BASE_URL}?i={imdb_id}&apikey={OMDB_API_KEY}"
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

def update_poster(imdb_id, poster_url):
    """Update poster URL in database"""
    if not poster_url or poster_url == 'N/A':
        print(f"⚠️  No poster URL for {imdb_id}")
        return False
    
    sql = f"UPDATE movies SET poster_url = {escape_sql(poster_url)}, updated_at = NOW() WHERE imdb_id = {escape_sql(imdb_id)};"
    
    cmd = ['mysql', '-h', DB_HOST, '-P', DB_PORT, '-u', DB_USERNAME, DB_DATABASE]
    if DB_PASSWORD:
        cmd.insert(5, f"-p{DB_PASSWORD}")
    
    try:
        result = subprocess.run(cmd, input=sql, capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            print(f"✅ Updated poster for {imdb_id}: {poster_url[:50]}...")
            return True
        else:
            print(f"❌ Error: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ Error executing SQL: {e}")
        return False

def get_movies_without_posters():
    """Get list of movies without posters from database"""
    sql = "SELECT imdb_id, title FROM movies WHERE poster_url IS NULL OR poster_url = '';"
    
    cmd = ['mysql', '-h', DB_HOST, '-P', DB_PORT, '-u', DB_USERNAME, DB_DATABASE, '-s', '-N']
    if DB_PASSWORD:
        cmd.insert(5, f"-p{DB_PASSWORD}")
    cmd.extend(['-e', sql])
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
        if result.returncode != 0:
            print(f"❌ Error querying database: {result.stderr}")
            return []
        
        movies = []
        for line in result.stdout.strip().split('\n'):
            if line:
                parts = line.split('\t')
                if len(parts) >= 2:
                    movies.append({'imdb_id': parts[0], 'title': parts[1]})
        return movies
    except Exception as e:
        print(f"❌ Error: {e}")
        return []

def main():
    print("🚀 Starting poster update for movies...")
    print(f"📋 Database: {DB_HOST}:{DB_PORT}/{DB_DATABASE}")
    print("=" * 60)
    
    # Get movies without posters
    movies = get_movies_without_posters()
    
    if not movies:
        print("✅ All movies already have posters!")
        return
    
    print(f"📋 Found {len(movies)} movies without posters:")
    for movie in movies:
        print(f"   - {movie['title']} ({movie['imdb_id']})")
    print("=" * 60)
    
    success = 0
    errors = 0
    
    # Update each movie
    for i, movie in enumerate(movies, 1):
        imdb_id = movie['imdb_id']
        title = movie['title']
        
        print(f"\n[{i}/{len(movies)}] Processing {title} ({imdb_id})...")
        
        # Fetch from OMDb API
        movie_data = fetch_movie(imdb_id)
        if not movie_data:
            errors += 1
            continue
        
        # Get poster URL
        poster_url = movie_data.get('Poster')
        if not poster_url or poster_url == 'N/A':
            print(f"⚠️  No poster available for {title}")
            errors += 1
            continue
        
        # Update database
        if update_poster(imdb_id, poster_url):
            success += 1
        else:
            errors += 1
        
        # Rate limiting
        time.sleep(1)
    
    print("\n" + "=" * 60)
    print("📊 Update Summary:")
    print(f"   ✅ Success: {success}")
    print(f"   ❌ Errors: {errors}")
    print(f"   📋 Total: {len(movies)}")
    print("=" * 60)

if __name__ == "__main__":
    main()


