FROM python:3.9-slim

# Устанавливаем зависимости для sqlite3 (уже есть в базовом образе)
# Для других БД нужно было бы: RUN apt-get update && apt-get install -y sqlite3

WORKDIR /app

# Копируем и устанавливаем зависимости
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем код приложения
COPY ./app .

# Создаём директорию для данных (будет перемонтирована через volume)
RUN mkdir -p /data

CMD ["python", "main.py"]
