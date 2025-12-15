import config
import telebot

bot = telebot.TeleBot(config.token)

@bot.message_handler(content_types=["text"])
def repeat_all_messages(message):
    # Отвечаем в формате: Вы написали: {текст}
    response = f"Вы написали: {message.text}"
    bot.send_message(message.chat.id, response)

if __name__ == '__main__':
    bot.infinity_polling()