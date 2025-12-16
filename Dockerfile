FROM python:3.9-slim

WORKDIR /app

# Устанавливаем зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем исходный код
COPY app/ ./app/
COPY entrypoint.sh .

# Устанавливаем entrypoint
ENTRYPOINT ["./entrypoint.sh"]
CMD ["python", "/app/app/bot.py"]
