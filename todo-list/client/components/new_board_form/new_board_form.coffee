# client/components/new_board_form/new_board_form.coffee
# тут хранятся пользователи добавленные к доске
# и придадим реактивность этому масиву с помощью
# объекта Tracker.Dependency
boardFormUsers = []
boardFormUsersDepend = new Tracker.Dependency

# сброс пользователей на форме
resetUsers = ->
  boardFormUsers = []
  boardFormUsersDepend.changed()

# переменные для пользовательского изображения
currentImage = null
currentImageUrl = null
currentImageDepend = new Tracker.Dependency

# сброс пользовательского изображения
resetImage = ->
  currentImage = null
  currentImageUrl = null
  currentImageDepend.changed()

# загрузка изображения на сервер
uploadImage = (boardId) ->
  if currentImage
    reader = new FileReader
    reader.onload = (e) ->
      # вызов серверного метода
      Meteor.call 'uploadBoardImage', boardId, e.target.result, (error) ->
        if error
          alertify.error error.message
        else
          alertify.success 'Image uploaded'
    reader.readAsBinaryString currentImage

# хелперы шаблона формы
Template.newBoardForm.helpers
  # реактивная функция, возвращающая массив добавленных пользователей
  boardFormUsers: ->
    boardFormUsersDepend.depend()
    boardFormUsers

  # колбек для автокомплита
  userSelected: ->
    (event, data) =>
      boardFormUsers ||= []
      boardFormUsers.push data
      boardFormUsers = _(boardFormUsers).uniq (u) -> u._id
      boardFormUsersDepend.changed()

  # задаем фоновое изображение для формы,
  # функция будет вызываться автоматически, так как имеет зависимость
  panelStyle: ->
    currentImageDepend.depend()
    currentImageUrl && "background-image: url(#{currentImageUrl})" || ''

# данный колбек срабатывает каждый раз, когда форма рендерится на страницу
Template.newBoardForm.rendered = ->
  resetUsers()
  resetImage()

# события формы
Template.newBoardForm.events
  # при отправки формы, мы создаем новую запись
  # если все прошло хорошо, загружаем изображение,
  # и сбрасываем форму
  'submit form': (event, template) ->
    event.preventDefault()
    form = event.target
    data = $(form).serializeJSON()
    BoardsCollection.create data.board, (error, id) ->
      if error
        alertify.error error.message
      else
        form.reset()
        alertify.success 'Board created'
        resetUsers()
        uploadImage(id)
        resetImage()

  # при выборе изображения меняем фон формы
  # и запоминаем текущий выбор
  'change #newBoardImage': (event, template) ->
    files = event.target.files
    image = files[0]
    unless image and image.type.match('image.*')
      resetImage()
      return

    currentImage = image

    reader = new FileReader
    reader.onload = (e) =>
      currentImageUrl = e.target.result
      currentImageDepend.changed()

    reader.readAsDataURL(image)
