# client/routers/users.coffee
Router.route '/profile', name: 'profile'
class @ProfileController extends RouteController

  # подписываемся на профайл если пользователь авторизован
  # на сайте
  waitOn: ->
    if Meteor.userId()
      @subscribe 'profile'

  # возвращаем в таком формате, потому что шаблон будет
  # еще несколько раз использоваться
  data: ->
    user: UsersCollection.findOne Meteor.userId()

  # если пользователь не авторизован оповещаем его
  # и редиректим на главную
  onBeforeAction: ->
    unless Meteor.userId()
      alertify.error 'Not authorized'
      @redirect '/'
    @next()
