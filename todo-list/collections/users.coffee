# collections/users.coffee
Users = Meteor.users

# статические методы и свойства
_.extend Users,
  # список полей доступных для редактирования
  allowFieldsForUpdate: ['profile', 'username']

  findUser: (id, options) ->
    Users.find { $or: [ { _id: id }, { username: id } ] }, options

  findOneUser: (id, options) ->
    Users.findOne { $or: [ { _id: id }, { username: id } ] }, options

# настройка коллекции
Users.allow
  # разрешаем обновлять только указанные поля
  # проверка будет проходить на сервере, так что
  # можно не волноваться, что кто-то изменит
  # данные ограничение
  update: (id, doc, fields, query) ->
    f = _.intersection(Users.allowFieldsForUpdate, fields)
    f.length == fields.length && Meteor.userId() == id

# добавляем методы и свойства в модель
Users.helpers

  # метод обновления пользователя, можно вызывать прямо на клиенте
  update: (data) ->
    Users.update @_id, data

  # метод для обновления, который будет только устанавливать данные
  # сразу позаботимся о запрещенных полях
  set: (data) ->
    d = {}
    f = _(Users.allowFieldsForUpdate)
    for key, value of data when f.include(key)
      d[key] = value
    @update $set: d

  # метод мержить текущие данные с переданными,
  # чтобы потом их можно было использовать для обновления
  # и нечего не потерять
  merge: (data) ->
    current = @get()
    @set _.deepExtend(current, data)

  # получение только данных модели, все методы и свойства,
  # указанные здесь находятся в прототипе
  get: ->
    r = {}
    r[key] = @[key] for key in _(@).keys()
    r

  # список все адресов почты
  getEmails: ->
    p = [@profile?.email]
    s = _(@services).map (value, key) -> value?.email
    e = _(@emails).map (value, key) -> value?.address
    _.compact p.concat(e, s)

  # основной адрес
  getEmail: ->
    @getEmails()[0]

  # публичная информация
  getUsername    : -> @username || @_id
  getName        : -> @profile?.name || "Anonymous"
  getPublicEmail : -> @profile?.email

  urlData: ->
    id: @getUsername()

  # вычисляем ссылку на граватар, на основе адреса почты
  # или хеша автоматически вычисленного при регистрации
  getAvatar: (size) ->
    size = Number(size) || 200
    options =
      s: size
      d: 'identicon'
      r: 'g'
    hash = "00000000000000000000000000000000"
    if email = @getPublicEmail()
      hash = Gravatar.hash(email)
    else
      hash = @profile?.emailHash || hash
    Gravatar.imageUrl hash, options

  # проверка сервиса используемого при регистрации
  isFromGithub:   -> @service == 'github'
  isFromGoogle:   -> @service == 'google'
  isFromPassword: -> @service == 'password'

  # текущий пользователь может редактировать
  # некоторые данные о себе
  isEditable: -> @_id == Meteor.userId()

# Экспорт коллекции
@UsersCollection = Users
