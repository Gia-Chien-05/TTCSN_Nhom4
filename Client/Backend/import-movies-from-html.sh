#!/bin/bash

# Script để import phim từ OMDb API vào database
# Lấy danh sách IMDb ID từ file HTML và thêm vào database

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Database config
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_DATABASE="${DB_DATABASE:-cinemax_db}"
DB_USERNAME="${DB_USERNAME:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"

# OMDb API
OMDB_API_KEY="fa85c569"
OMDB_BASE_URL="https://www.omdbapi.com/"

# Danh sách IMDb ID từ file HTML
declare -a IMDB_IDS=(
    "tt0111161"  # The Shawshank Redemption
    "tt0468569"  # The Dark Knight
    "tt0109830"  # Forrest Gump
    "tt0167260"  # The Lord of the Rings: The Return of the King
    "tt0137523"  # Fight Club
    "tt0110912"  # Pulp Fiction
    "tt0120737"  # The Lord of the Rings: The Fellowship of the Ring
    "tt3896198"  # Guardians of the Galaxy Vol. 2
    "tt4154796"  # Avengers: Endgame
    "tt4154756"  # Avengers: Infinity War
)

# Mapping tên phim tiếng Việt
declare -A VIETNAMESE_TITLES=(
    ["tt0111161"]="Nhà Tù Shawshank"
    ["tt0468569"]="Kỵ Sĩ Bóng Đêm"
    ["tt0109830"]="Forrest Gump"
    ["tt0167260"]="Chúa Tể Những Chiếc Nhẫn: Sự Trở Lại Của Nhà Vua"
    ["tt0137523"]="Câu Lạc Bộ Đấu Sĩ"
    ["tt0110912"]="Pulp Fiction"
    ["tt0120737"]="Chúa Tể Những Chiếc Nhẫn: Hiệp Hội Nhẫn Thần"
    ["tt3896198"]="Vệ Binh Dải Ngân Hà 2"
    ["tt4154796"]="Biệt Đội Siêu Anh Hùng: Hồi Kết"
    ["tt4154756"]="Biệt Đội Siêu Anh Hùng: Cuộc Chiến Vô Cực"
)

echo "🚀 Starting movie import from OMDb API..."
echo "📋 Database: $DB_HOST:$DB_PORT/$DB_DATABASE"
echo "📋 Total movies to import: ${#IMDB_IDS[@]}"
echo "============================================================"

# MySQL command with password
MYSQL_CMD="mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME"
if [ -n "$DB_PASSWORD" ]; then
    MYSQL_CMD="$MYSQL_CMD -p$DB_PASSWORD"
fi
MYSQL_CMD="$MYSQL_CMD $DB_DATABASE"

# Test database connection
if ! $MYSQL_CMD -e "SELECT 1;" > /dev/null 2>&1; then
    echo -e "${RED}❌ Cannot connect to database${NC}"
    exit 1
fi

success_count=0
skip_count=0
error_count=0

# Function to escape SQL strings
escape_sql() {
    echo "$1" | sed "s/'/''/g"
}

# Function to parse duration
parse_duration() {
    local runtime="$1"
    if [ -z "$runtime" ] || [ "$runtime" = "N/A" ]; then
        echo "NULL"
    else
        echo "$runtime" | sed 's/ min//' | xargs
    fi
}

# Function to parse rating
parse_rating() {
    local rating="$1"
    if [ -z "$rating" ] || [ "$rating" = "N/A" ]; then
        echo "NULL"
    else
        echo "$rating" | cut -d'/' -f1 | xargs
    fi
}

# Function to parse release date
parse_release_date() {
    local date_str="$1"
    if [ -z "$date_str" ] || [ "$date_str" = "N/A" ]; then
        echo "NULL"
    else
        # Try to parse date (format: "16 Jul 2010" -> "2010-07-16")
        if date -d "$date_str" +%Y-%m-%d 2>/dev/null; then
            date -d "$date_str" +%Y-%m-%d
        else
            echo "NULL"
        fi
    fi
}

# Function to get first item from comma-separated list
get_first_item() {
    local str="$1"
    if [ -z "$str" ] || [ "$str" = "N/A" ]; then
        echo "NULL"
    else
        echo "$str" | cut -d',' -f1 | xargs
    fi
}

# Process each IMDb ID
for i in "${!IMDB_IDS[@]}"; do
    imdb_id="${IMDB_IDS[$i]}"
    index=$((i + 1))
    total=${#IMDB_IDS[@]}
    
    echo ""
    echo "[$index/$total] Processing $imdb_id..."
    
    # Check if movie already exists
    existing=$(echo "SELECT id FROM movies WHERE imdb_id = '$imdb_id';" | $MYSQL_CMD -s -N 2>/dev/null || echo "")
    if [ -n "$existing" ]; then
        echo -e "${YELLOW}⏭️  Movie $imdb_id already exists, skipping...${NC}"
        skip_count=$((skip_count + 1))
        continue
    fi
    
    # Fetch from OMDb API
    echo "   Fetching from OMDb API..."
    response=$(curl -s "${OMDB_BASE_URL}?i=${imdb_id}&apikey=${OMDB_API_KEY}&plot=full" 2>/dev/null || echo "")
    
    if [ -z "$response" ]; then
        echo -e "${RED}❌ Error fetching $imdb_id${NC}"
        error_count=$((error_count + 1))
        continue
    fi
    
    # Check if API returned error
    if echo "$response" | grep -q '"Response":"False"'; then
        error_msg=$(echo "$response" | grep -o '"Error":"[^"]*"' | cut -d'"' -f4)
        echo -e "${RED}❌ API Error for $imdb_id: $error_msg${NC}"
        error_count=$((error_count + 1))
        continue
    fi
    
    # Parse JSON data (using basic parsing since we don't have jq by default)
    # Extract fields from JSON
    title=$(echo "$response" | grep -o '"Title":"[^"]*"' | cut -d'"' -f4)
    plot=$(echo "$response" | grep -o '"Plot":"[^"]*"' | cut -d'"' -f4)
    genre=$(echo "$response" | grep -o '"Genre":"[^"]*"' | cut -d'"' -f4)
    director=$(echo "$response" | grep -o '"Director":"[^"]*"' | cut -d'"' -f4)
    actors=$(echo "$response" | grep -o '"Actors":"[^"]*"' | cut -d'"' -f4)
    released=$(echo "$response" | grep -o '"Released":"[^"]*"' | cut -d'"' -f4)
    runtime=$(echo "$response" | grep -o '"Runtime":"[^"]*"' | cut -d'"' -f4)
    imdb_rating=$(echo "$response" | grep -o '"imdbRating":"[^"]*"' | cut -d'"' -f4)
    language=$(echo "$response" | grep -o '"Language":"[^"]*"' | cut -d'"' -f4)
    country=$(echo "$response" | grep -o '"Country":"[^"]*"' | cut -d'"' -f4)
    poster=$(echo "$response" | grep -o '"Poster":"[^"]*"' | cut -d'"' -f4)
    
    # Get Vietnamese title
    title_vietnamese="${VIETNAMESE_TITLES[$imdb_id]}"
    
    # Prepare values
    title_escaped=$(escape_sql "$title")
    title_vn_escaped=$(escape_sql "$title_vietnamese")
    plot_escaped=$(escape_sql "$plot")
    genre_escaped=$(escape_sql "$genre")
    director_escaped=$(escape_sql "$director")
    actors_escaped=$(escape_sql "$actors")
    language_escaped=$(escape_sql "$(get_first_item "$language")")
    country_escaped=$(escape_sql "$(get_first_item "$country")")
    poster_escaped=$(escape_sql "$poster")
    
    duration=$(parse_duration "$runtime")
    rating=$(parse_rating "$imdb_rating")
    release_date=$(parse_release_date "$released")
    
    # Set defaults
    price="85000.00"
    vip_price="120000.00"
    status="NOW_SHOWING"
    
    # Build SQL query
    sql="INSERT INTO movies (
        imdb_id, title, title_vietnamese, description, genre, director, actors,
        release_date, duration, rating, language, country, poster_url, trailer_url,
        status, price, vip_price, created_at, updated_at
    ) VALUES (
        '$imdb_id',
        '$title_escaped',
        $(if [ -n "$title_vn_escaped" ]; then echo "'$title_vn_escaped'"; else echo "NULL"; fi),
        $(if [ -n "$plot_escaped" ] && [ "$plot_escaped" != "N/A" ]; then echo "'$plot_escaped'"; else echo "NULL"; fi),
        $(if [ -n "$genre_escaped" ] && [ "$genre_escaped" != "N/A" ]; then echo "'$genre_escaped'"; else echo "NULL"; fi),
        $(if [ -n "$director_escaped" ] && [ "$director_escaped" != "N/A" ]; then echo "'$director_escaped'"; else echo "NULL"; fi),
        $(if [ -n "$actors_escaped" ] && [ "$actors_escaped" != "N/A" ]; then echo "'$actors_escaped'"; else echo "NULL"; fi),
        $(if [ "$release_date" != "NULL" ]; then echo "'$release_date'"; else echo "NULL"; fi),
        $(if [ "$duration" != "NULL" ]; then echo "$duration"; else echo "NULL"; fi),
        $(if [ "$rating" != "NULL" ]; then echo "$rating"; else echo "NULL"; fi),
        $(if [ "$language_escaped" != "NULL" ]; then echo "'$language_escaped'"; else echo "NULL"; fi),
        $(if [ "$country_escaped" != "NULL" ]; then echo "'$country_escaped'"; else echo "NULL"; fi),
        $(if [ -n "$poster_escaped" ] && [ "$poster_escaped" != "N/A" ]; then echo "'$poster_escaped'"; else echo "NULL"; fi),
        NULL,
        '$status',
        $price,
        $vip_price,
        NOW(),
        NOW()
    );"
    
    # Execute SQL
    if echo "$sql" | $MYSQL_CMD > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Inserted: $title ($imdb_id)${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ Error inserting $title${NC}"
        error_count=$((error_count + 1))
    fi
    
    # Rate limiting
    sleep 1
done

# Summary
echo ""
echo "============================================================"
echo "📊 Import Summary:"
echo -e "   ${GREEN}✅ Success: $success_count${NC}"
echo -e "   ${YELLOW}⏭️  Skipped: $skip_count${NC}"
echo -e "   ${RED}❌ Errors: $error_count${NC}"
echo "   📋 Total: ${#IMDB_IDS[@]}"
echo "============================================================"


