import config
import telebot

bot = telebot.TeleBot(config.token)

@bot.message_handler(content_types=["text"])
def repeat_all_messages(message):
    # Эхо-бот: повторяет сообщение пользователя
    bot.send_message(message.chat.id, message.text)

if __name__ == '__main__':
    bot.infinity_polling()