# client/components/profile/profile.coffee
Template.profile.helpers
  fieldUsername: ->
    data:         @
    defaultValue: @getUsername()
    placeholder: 'Username'
    scope:       'user'
    path:        'username'
    iconSymbol:  '@'

  fieldName: ->
    data:         @
    defaultValue: @getName()
    placeholder: 'Name'
    scope:       'user'
    path:        'profile.name'
    icon:        'user'

  fieldEmail: ->
    data:         @
    defaultValue: @getPublicEmail()
    placeholder: 'Public email'
    scope:       'user'
    path:        'prfile.email'
    icon:        'envelope'

Template.profile.events
  # отлавливаем изменения в редактируемых полях
  # и обновляем пользователя
  'changed .EditableFiled': (event, template, data) ->
    user = template.data?.user
    return unless user
    data = data.user
    user.merge data
