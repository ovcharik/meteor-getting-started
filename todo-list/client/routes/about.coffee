# client/routers/about.coffee
Router.route '/about',
  name: 'about'
  controller: AboutController

class AboutController extends RouteController

  action: ->
    super()
