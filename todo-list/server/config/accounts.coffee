# server/config/accounts.coffee
emailTemplates =
  from: 'TODO List <meteor-todo-list@yandex.ru>'
  siteName: 'Meteor. TODO List.'

# заменяем стандартные настройки для почты
_.deepExtend Accounts.emailTemplates, emailTemplates

# включаем верификацию
Accounts.config
  sendVerificationEmail: true

# добавляем кастомную логику при регистрации пользователей
Accounts.onCreateUser (options = {}, user) ->
  u = UsersCollection._transform(user)
  options.profile ||= {}
  # сохраняем хеш адреса, чтобы можно было получит аватар для пользователя
  # у которого не указан публичный адрес почты
  options.profile.emailHash = Gravatar.hash(u.getEmail() || "")
  # запоминаем сервис, через который пользователь зарегистрировался
  options.service = _(user.services).keys()[0] if user.services
  # сохраняем дополнительные параметры и возвращаем объект,
  # который запишется в бд
  _.extend user, options
