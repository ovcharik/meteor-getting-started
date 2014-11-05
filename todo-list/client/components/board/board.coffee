# client/components/board/board.coffee
filter = new ReactiveVar('all')

Template.board.helpers
  userSelected: ->
    (event, data) =>
      @addUser data._id

  filteredTasks: ->
    switch filter.get()
      when 'todo'  then @getTodoTasks()
      when 'doing' then @getDoingTasks()
      when 'done'  then @getDoneTasks()
      else @getTasks()

Template.board.rendered = ->
  filter.set 'all'
  image = @data?.background?.url
  if image
    $("body").css('background-image', "url(#{image})")

Template.board.destroyed = ->
  $("body").css('background-image', "")

Template.board.events
  'submit form#addTask': (event, value) ->
    event.preventDefault()
    form = event.currentTarget
    data = $(form).serializeJSON()
    @addTask data.task, (err, id) =>
      if err
        alertify.error err.message
      else
        form.reset()

  'click .ToTodo'  : -> @toTodo()
  'click .ToDoing' : -> @toDoing()
  'click .ToDone'  : -> @toDone()
  'click .Remove'  : -> @remove()

  'change .Filter': (event, template) ->
    filter.set event.target.value
