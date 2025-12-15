# Учебный бот

После клонирования необходимо создать и активировать виртуальное окружение, например, в linux и mac:
python3 -m venv env
source env/bin/activate

## Установка:

pip install -r requirements.txt

Скопировать config.py.example в config.py и изменить его

## Запуск:

python main.py
## Работа с переменными окружения

После обновления бот использует переменные окружения для конфигурации.

### Быстрый запуск:
```bash
docker run -e token="ВАШ_ТОКЕН" telegram-bot

