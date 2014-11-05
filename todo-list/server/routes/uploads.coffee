# server/routes/uploads.coffee
fs = Meteor.npmRequire 'fs'

Router.route '/uploads/:file',
  where: 'server'
  action: ->
    try
      filepath = Meteor.getUploadFilePath(@params.file)
      file = fs.readFileSync(filepath)
      @response.writeHead 200, { 'Content-Type': 'image/jpg' }
      @response.end file, 'binary'
    catch e
      @response.writeHead 404, { 'Content-Type': 'text/plain' }
      @response.end '404. Not found.'
