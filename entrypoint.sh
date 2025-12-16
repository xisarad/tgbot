#!/bin/bash
set -e

echo "Starting initialization..."

# Инициализируем БД если не существует
if [ ! -f "/app/data/bot_database.db" ]; then
    echo "Initializing database..."
    python /app/app/init_db.py
    echo "Database created!"
else
    echo "Database already exists, skipping initialization"
fi

# Запускаем основной процесс
exec "$@"
