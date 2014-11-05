Meteor.methods
  usersAutocomplete: (q) ->
    UsersCollection.findAutocomplete q,
      fields:
        username: 1
        profile:  1
      limit: 5
    .fetch()
