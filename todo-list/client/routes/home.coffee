# client/routers/home.coffee
Router.route '/',
  name: 'home'
  controller: HomeController

class HomeController extends RouteController

  action: ->
    super()
