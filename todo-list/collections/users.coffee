# collections/users.coffee
Users = Meteor.users

# Добавляем методы и свойства в модель
Users.helpers
  getEmails: ->
    s = _(@services).map (value, key) -> value?.email
    e = _(@emails).map (value, key) -> value?.address
    _.compact e.concat(s)

  getEmail: ->
    @getEmails()[0]

  getAvatar: (size = 200, def = 'identicon') ->
    throw 'Only client method' if Meteor.isServer
    durl = "http://www.gravatar.com/avatar/00000000000000000000000000000000"
    url = @profile?.avatar || durl
    options =
      s: size
      d: def
      r: 'g'
    url + "?" + $.param(options)

  isFromGithub:   -> @profile?.service == 'github'
  isFromGoogle:   -> @profile?.service == 'google'
  isFromPassword: -> @profile?.service == 'password'

# Экспорт коллекции
@UsersCollection = Users
