# server/publications/user.coffee
Meteor.publish 'user', (id) ->
  UsersCollection.findUser id,
    fields:
      service: 1
      username: 1
      profile: 1
    limit: 1
