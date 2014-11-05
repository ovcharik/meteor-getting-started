# client/lib/base_profile_controller.coffee
class @BaseProfileController extends PagableRouteController

  # используем уже готовый шаблон
  template: 'profile'

  currentUserId: ->
    false

  # подписываемся на доски текущего пользователя
  subscriptions: ->
    if @currentUserId()
      [
        @subscribe 'user', @currentUserId()
        @subscribe 'boards', @currentUserId(), @limit('boards')
      ]

  # возвращаем данные о текущем пользователе, если такой имеется
  data: ->
    if @currentUserId()
      {
        user:   UsersCollection.findOne @currentUserId()
        boards: BoardsCollection.findByUser @currentUserId(), {sort: { createdAt: -1 }}
      }

  loaded: (name) ->
    switch name
      when 'boards' then @limit('boards') > @data().boards.count()
      else false

  onRun: ->
    if @currentUserId()
      @resetLimit('boards')
    @next()
