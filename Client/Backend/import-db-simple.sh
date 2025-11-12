#!/bin/bash
# Import database đơn giản với config cố định
export DB_HOST=127.0.0.1
export DB_PORT=3306
export DB_DATABASE=cinemax_db
export DB_USERNAME=root
export DB_PASSWORD=

echo "📦 Importing database to $DB_HOST:$DB_PORT/$DB_DATABASE..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" < database/schema.sql && echo "✅ Done!" || echo "❌ Failed!"
