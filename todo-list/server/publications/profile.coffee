# server/publications/profile.coffee
Meteor.publish 'profile', ->
  if @userId
    UsersCollection.find { _id: @userId },
      fields:
        username: 1
        profile: 1
        emails: 1
  else
    @ready()
    return
