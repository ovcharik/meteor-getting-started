# server/config/smtp/coffee
smtp =
  username: "meteor-todo-list@yandex.ru"
  password: "meteor-todo-list1234"
  server:   "smtp.yandex.ru"
  port:     "587"

# Экранируем символы
_(smtp).each (value, key) -> smtp[key] = encodeURIComponent(value)

# Шаблон url доступа к smtp
url = "smtp://#{smtp.username}:#{smtp.password}@#{smtp.server}:#{smtp.port}"

# Задаем переменную окружения, метеор будет использовать данные из нее
process.env.MAIL_URL = url
