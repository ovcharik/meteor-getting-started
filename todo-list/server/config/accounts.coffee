# server/config/accounts.coffee
emailTemplates =
  from: 'TODO List <meteor-todo-list@yandex.ru>'
  siteName: 'Meteor. TODO List.'

# Заменяем стандартные настройки для почты
_.deepExtend Accounts.emailTemplates, emailTemplates

# Включаем верификацию
Accounts.config
  sendVerificationEmail: true
