Meteor.startup ->
  fs = Meteor.npmRequire 'fs'
  try
    fs.mkdirSync Meteor.getUploadFilePath('')
  catch e
