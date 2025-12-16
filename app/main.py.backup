import config
import telebot
import sqlite3
import os
from datetime import datetime

# Инициализируем бота
bot = telebot.TeleBot(config.token)

# Подключаемся к базе данных
def init_db():
    conn = sqlite3.connect('/data/bot_database.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            user_id INTEGER PRIMARY KEY,
            username TEXT,
            first_name TEXT,
            last_name TEXT,
            registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            message_count INTEGER DEFAULT 0
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS messages (
            message_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            text TEXT,
            sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (user_id)
        )
    ''')
    conn.commit()
    conn.close()
    print("✅ База данных инициализирована")

# Регистрация/обновление пользователя
def register_user(user_id, username, first_name, last_name):
    conn = sqlite3.connect('/data/bot_database.db')
    cursor = conn.cursor()
    
    cursor.execute('''
        INSERT OR REPLACE INTO users (user_id, username, first_name, last_name, message_count)
        VALUES (?, ?, ?, ?, COALESCE((SELECT message_count FROM users WHERE user_id = ?), 0))
    ''', (user_id, username, first_name, last_name, user_id))
    
    conn.commit()
    conn.close()

# Увеличиваем счётчик сообщений
def increment_message_count(user_id):
    conn = sqlite3.connect('/data/batabase.db')
    cursor = conn.cursor()
    cursor.execute('UPDATE users SET message_count = message_count + 1 WHERE user_id = ?', (user_id,))
    conn.commit()
    conn.close()

# Сохраняем сообщение
def save_message(user_id, text):
    conn = sqlite3.connect('/data/bot_database.db')
    cursor = conn.cursor()
    cursor.execute('INSERT INTO messages (user_id, text) VALUES (?, ?)', (user_id, text))
    conn.commit()
    conn.close()

# Обработчик команды /start
@bot.message_handler(commands=['start'])
def send_welcome(message):
    user_id = message.from_user.id
    username = message.from_user.username
    first_name = message.from_user.first_name
    last_name = message.from_user.last_name
    
    # Регистрируем пользователя
    register_user(user_id, username, first_name, last_name)
    
    # Приветственное сообщение
    welcome_text = f"""
Привет, {first_name}! 👋

Я бот с базой данных. Вот что я умею:
/start - это сообщение
/stats - ваша статистика
/users - список всех пользователей
/myid - ваш ID

Все ваши сообщения сохраняются в базе данных.
    """
    bot.reply_to(message, welcome_text)
    print(f"📝 Пользователь {user_id} зарегистрирован")

# Обработчик команды /stats
@bot.message_handler(commands=['stats'])
def show_stats(message):
    user_id = message.from_user.id
    conn = sqlite3.connect('/data/bot_database.db')
    cursor = conn.cursor()
    
    cursor.execute('SELECT message_count FROM users WHERE user_id = ?', (user_id,))
    result = cursor.fetchone()
    
    if result:
        count = result[0]
        bot.reply_to(message, f"📊 Ваша статистика:\nОтправлено сообщений: {count}")
    else:
        bot.reply_to(message, "Вы ещё не зарегистрированы. Напишите что-нибудь!")
    
    conn.close()

# Обработчик команды /users (только для админов)
@bot.message_handler(commands=['users'])
def show_users(message):
    # Простая проверка на админа (можно вынести в config.py)
    if message.from_user.id == config.admin_id:
        conn = sqlite3.connect('/data/bot_database.db')
        cursor = conn.cursor()
        
        cursor.execute('SELECT user_id, username, first_name, message_count FROM users ORDER BY registered_at DESC LIMIT 10')
        users = cursor.fetchall()
        
        response = "👥 Последние 10 пользователей:\n"
        for user in users:
            response += f"ID: {user[0]}, Имя: {user[2]}, Сообщений: {user[3]}\n"
        
        bot.reply_to(message, response)
        conn.close()
    else:
        bot.reply_to(message, "Эта команда только для администратора.")

# Обработчик команды /myid
@bot.message_handler(commands=['myid'])
def show_myid(message):
    user_id = message.from_user.id
    bot.reply_to(message, f"🆔 Ваш ID: {user_id}\nСохраните его для обращения в поддержку.")

# Обработчик всех текстовых сообщений
@bot.message_handler(content_types=['text'])
def handle_text(message):
    user_id = message.from_user.id
    text = message.text
    
    # Регистрируем пользователя если его нет
    register_user(user_id, message.from_user.username, 
                  message.from_user.first_name, message.from_user.last_name)
    
    # Сохраняем сообщение в БД
    save_message(user_id, text)
    
    # Увеличиваем счётчик
    increment_message_count(user_id)
    
    # Ответ
    response = f"Вы написали: {text}\n(сообщение сохранено в БД)"
    bot.send_message(message.chat.id, response)
    
    # Логируем
    print(f"💾 Сообщение от {user_id} сохранено: {text[:20]}...")

# Запуск бота
if __name__ == '__main__':
    print("=" * 50)
    print("🤖 Бот с БД запускается...")
    print(f"📂 База данных: /data/bot_database.db")
    
    # Инициализируем БД
    init_db()
    
    print("✅ Бот готов к работе!")
    print("=" * 50)
    
    # Запускаем бота
    bot.infinity_polling()
