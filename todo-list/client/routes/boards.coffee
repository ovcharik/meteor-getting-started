# client/routes/boards.coffee
Router.route '/boards', name: 'boards'
class @BoardsController extends PagableRouteController

  perPage: 20

  subscriptions: ->
    @subscribe 'boards', null, @limit()

  data: ->
    boards: BoardsCollection.find( {}, {sort: {createdAt: -1}} )

  loaded: ->
    @limit() > BoardsCollection.find().count()

  onRun: ->
    @resetLimit()
    @next()
