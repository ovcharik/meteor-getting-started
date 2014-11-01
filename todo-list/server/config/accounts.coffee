# server/config/accounts.coffee
emailTemplates =
  from: 'TODO List <meteor-todo-list@yandex.ru>'
  siteName: 'Meteor. TODO List.'

# Заменяем стандартные настройки для почты
_.deepExtend Accounts.emailTemplates, emailTemplates

# Включаем верификацию
Accounts.config
  sendVerificationEmail: true

Accounts.onCreateUser (options = {}, user) ->
  u = UsersCollection._transform(user)
  options.profile ||= {}
  options.profile.avatar = Gravatar.imageUrl(u.getEmail())
  _.extend user, options
