import os

# Токен бота из переменной окружения
token = os.getenv('token')

# ID администратора (можно тоже из переменной окружения)
admin_id = int(os.getenv('ADMIN_ID', '123456789'))

# Проверка что токен установлен
if not token:
    print("❌ ОШИБКА: Токен не найден в переменных окружения")
    print("   Установите: docker run -e token='ВАШ_ТОКЕН' ...")
    exit(1)

print(f"✅ Токен загружен (длина: {len(token)})")
print(f"✅ Admin ID: {admin_id}")
