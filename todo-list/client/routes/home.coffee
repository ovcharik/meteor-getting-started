# client/routers/home.coffee
Router.route '/', name: 'home'
class @HomeController extends RouteController

  action: ->
    console.log 'Home Controller'
    super()
