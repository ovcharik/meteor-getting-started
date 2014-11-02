# client/routers/users.coffee
Router.route '/users', name: 'users'
class @UsersController extends PagableRouteController

  perPage: 20

  subscriptions: ->
    @subscribe 'users', @limit()

  data: ->
    {
      users: UsersCollection.find()
      count: UsersCollection.find().count()
    }

  loaded: ->
    @limit() > UsersCollection.find().count()

  onRun: ->
    @resetLimit()
    @next()
