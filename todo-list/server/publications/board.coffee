# server/publications/board.coffee
Meteor.publish 'board', (id) ->
  cursor = BoardsCollection.find { _id: id }

  userFindOptions =
    fields:
      service: 1
      username: 1
      profile: 1

  addUsers = (id, doc) =>
    users = [doc.owner].concat(doc.users)
    UsersCollection.find({_id: { $in: users }}, userFindOptions).forEach (u) =>
      @added 'users', u._id, u

  handle = cursor.observeChanges
    changed: addUsers
    added:   addUsers

  @onStop ->
    handle.stop()

  return [
    cursor
    TasksCollection.findByBoard(id)
  ]
