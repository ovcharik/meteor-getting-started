# client/routers/home.coffee
Router.route '/', name: 'home'
class @HomeController extends PagableRouteController

  # авторизован ли пользователь?
  isUserPresent: ->
    !!Meteor.userId()

  # подписываемся на профайл если пользователь авторизован
  # на сайте
  waitOn: ->
    if @isUserPresent()
      @subscribe 'profile'

  # возвращаем данные о текущем пользователе, если такой имеется
  data: ->
    if @isUserPresent()
      { user: UsersCollection.findOne Meteor.userId() }

  # рендерим шаблон профайла если пользователь авторизован
  # и домашнюю страницу в противном случае
  action: ->
    if @isUserPresent()
      @render 'profile'
    else
      super()
