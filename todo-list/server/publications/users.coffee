# server/publications/users.coffee
Meteor.publish 'users', (page = 1) ->
  perPage = 20
  limit = perPage * page
  UsersCollection.find {},
    fields:
      username: 1
      profile: 1
    limit: limit
