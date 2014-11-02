# server/publications/profile.coffee
Meteor.publish 'profile', ->
  # проверям авторизован ли пользователь,
  # запрашивающий подписку
  if @userId
    # подписываем на его запись в бд
    UsersCollection.find { _id: @userId },
      fields:
        service: 1
        username: 1
        profile: 1
        emails: 1
  else
    # просто говорим, что все готово
    @ready()
    return
