# server/publications/boards.coffee
Meteor.publish 'boards', (userId, limit = 20) ->
  findOptions =
    limit: limit
    sort: { createdAt: -1 }

  if userId
    # доски конкретного пользователя
    cursor = BoardsCollection.findByUser userId, findOptions
  else
    # все доски
    cursor = BoardsCollection.find {}, findOptions

  inited = false
  userFindOptions =
    fields:
      service: 1
      username: 1
      profile: 1

  # колбек для добавления создателя доски к подписке
  addUser = (id, fields) =>
    if inited
      userId = fields.owner
      @added 'users', userId, UsersCollection.findOne(userId, userFindOptions)

  # отслеживаем изменения в коллекции,
  # что бы добавлять пользователей к подписке
  handle = cursor.observeChanges
    added: addUser
    changed: addUser

  inited = true
  # при инициализации сразу же добавляем пользователей,
  # при помощи одного запроса в бд
  userIds = cursor.map (b) -> b.owner
  UsersCollection.find({_id: { $in: userIds }}, userFindOptions).forEach (u) =>
    @added 'users', u._id, u

  # перестаем слушать курсор коллекции, при остановке подписки
  @onStop ->
    handle.stop()

  return cursor
