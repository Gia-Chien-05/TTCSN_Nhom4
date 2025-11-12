#!/bin/bash
# Script test API Movies

BASE_URL="http://localhost:8080/api"

echo "🎬 Testing Movies API"
echo "===================="
echo ""
echo "Base URL: $BASE_URL"
echo ""

# Test 1: Get all movies
echo "📋 Test 1: GET /movies - Get all movies"
echo "----------------------------------------"
curl -s "$BASE_URL/movies" | jq '.' 2>/dev/null || curl -s "$BASE_URL/movies"
echo ""
echo ""

# Test 2: Get movie by ID
echo "📋 Test 2: GET /movies/1 - Get movie by ID"
echo "----------------------------------------"
curl -s "$BASE_URL/movies/1" | jq '.' 2>/dev/null || curl -s "$BASE_URL/movies/1"
echo ""
echo ""

# Test 3: Get movies by status
echo "📋 Test 3: GET /movies/status/NOW_SHOWING - Get movies by status"
echo "----------------------------------------"
curl -s "$BASE_URL/movies/status/NOW_SHOWING" | jq '.' 2>/dev/null || curl -s "$BASE_URL/movies/status/NOW_SHOWING"
echo ""
echo ""

# Test 4: Search movies
echo "📋 Test 4: GET /movies/search?keyword=Matrix - Search movies"
echo "----------------------------------------"
curl -s "$BASE_URL/movies/search?keyword=Matrix" | jq '.' 2>/dev/null || curl -s "$BASE_URL/movies/search?keyword=Matrix"
echo ""
echo ""

# Test 5: Get movie by IMDB ID
echo "📋 Test 5: GET /movies/imdb/tt1375666 - Get movie by IMDB ID"
echo "----------------------------------------"
curl -s "$BASE_URL/movies/imdb/tt1375666" | jq '.' 2>/dev/null || curl -s "$BASE_URL/movies/imdb/tt1375666"
echo ""
echo ""

echo "✅ Test completed!"
echo ""
echo "💡 Tip: Install jq for better JSON formatting:"
echo "   sudo apt install jq -y"





