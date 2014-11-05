# client/routers/home.coffee
Router.route '/', name: 'home'
class @HomeController extends BaseProfileController

  # авторизован ли пользователь?
  isUserPresent: ->
    !!Meteor.userId()

  # ищем пользователя
  currentUserId: ->
    Meteor.userId()

  # рендерим шаблон профайла если пользователь авторизован
  # и домашнюю страницу в противном случае
  action: ->
    if @isUserPresent()
      @render 'profile'
    else
      @render 'home'
