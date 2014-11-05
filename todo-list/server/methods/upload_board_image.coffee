# server/methods/upload_board_image.coffee
# подключаем библиотеку для обработки изображения
gm = Meteor.npmRequire 'gm'

# ресайз и сохранение изображения
resizeAndWriteAsync = (buffer, path, w, h, cb) ->
  gm(buffer)
  .options({imageMagick: true})
  .resize(w, "#{h}^", ">")
  .gravity('Center')
  .crop(w, h, 0, 0)
  .noProfile()
  .write(path, cb)

# делаем обработку изображения синхронной
resizeAndWrite = Meteor.wrapAsync resizeAndWriteAsync

# регистрируем метод для загрузки изображения к доске
Meteor.methods
  uploadBoardImage: (boardId, data) ->
    board = BoardsCollection.findOne(boardId)
    if board.owner != @userId
      throw new Meteor.Error('notAuthorized', 'Not authorized')

    data  = new Buffer data, 'binary'
    name  = Meteor.uuid() # уникальное имя для изображения
    path  = Meteor.getUploadFilePath name

    resizeAndWrite data, "#{path}.jpg", 1920, 1080
    resizeAndWrite data, "#{path}_thumb.jpg", 600, 400

    # сохраняем данные к доске
    BoardsCollection.update { _id: boardId },
      $set:
        background:
          url:   "/uploads/#{name}.jpg"
          thumb: "/uploads/#{name}_thumb.jpg"
    return
