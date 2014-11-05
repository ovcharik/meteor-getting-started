# client/routes/user_show.coffee
Router.route '/users/:id', name: 'users_show'
class @UsersShowController extends BaseProfileController

  currentUserId: ->
    @params.id
