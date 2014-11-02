# server/publications/users.coffee
Meteor.publish 'users', (limit = 20) ->
  UsersCollection.find {},
    fields:
      username: 1
      profile: 1
    limit: limit
