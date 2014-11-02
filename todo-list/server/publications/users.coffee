# server/publications/users.coffee
Meteor.publish 'users', (limit = 20) ->
  UsersCollection.find {},
    fields:
      service: 1
      username: 1
      profile: 1
    limit: limit
