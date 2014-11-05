# server/lib/meteor.coffee
Meteor.getUploadFilePath = (filename) ->
  "#{process.env.PWD}/.uploads/#{filename}"
