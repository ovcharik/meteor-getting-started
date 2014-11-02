# client/components/profile/profile.coffee
Template.profile.events
  # отлавливаем изменения в редактируемых полях
  # и обновляем пользователя
  'changed .EditableFiled': (event, template, data) ->
    user = template.data?.user
    return unless user
    data = data.user
    user.merge data
