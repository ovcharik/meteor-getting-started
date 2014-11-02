# client/routers/user_show.coffee
Router.route '/users/:id', name: 'users_show'
class @UsersShowController extends PagableRouteController

  # используем уже готовый шаблон
  template: 'profile'

  # подписываемся на нужного пользователя
  waitOn: ->
    @subscribe 'user', @params.id

  # ищем нужного пользователя
  data: ->
    user: UsersCollection.findOneUser(@params.id)
