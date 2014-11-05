# client/routes/boards_show.coffee
Router.route '/boards/:id', name: 'boards_show'
class @BoardsShowController extends PagableRouteController

  template: 'board'

  currentBoardId: ->
    @params.id

  waitOn: ->
    @subscribe 'board', @currentBoardId()

  data: ->
    BoardsCollection.findOne @currentBoardId()
