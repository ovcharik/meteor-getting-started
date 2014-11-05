# collections/boards.coffee
# схема данных
boardsSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true

  'description':
    type: String
    optional: true # не обязательное поле

  # автоматически генерируем автора доски
  'owner':
    type: String
    autoValue: (doc) ->
      if @isInsert
        return @userId
      if @isUpsert
        return { $setOnInsert: @userId }
      @unset()

  # список пользователей доски
  'users':
    type: [String]
    defaultValue: []

  'users.$':
    type: String
    regEx: SimpleSchema.RegEx.Id

  'background'      : { type: Object, optional: true }
  'background.url'  : { type: String, optional: true }
  'background.thumb': { type: String, optional: true }


# регистрируем коллекцию и добавляем схему
Boards = new Meteor.Collection 'boards'
Boards.attachSchema boardsSchema


# защита данных
Boards.allow
  # создавать доски может любой авторизованный пользователь
  insert: (userId, doc) ->
    userId && true
  # обновлять данные может только создатель доски
  update: (userId, doc) ->
    userId && userId == doc.owner


# статические методы
_.extend Boards,
  findByUser: (userId = Meteor.userId(), options) ->
    Boards.find
      $or: [
        { users: userId }
        { owner: userId }
      ]
    , options

  create: (data, cb) ->
    Boards.insert data, cb

# методы объектов
Boards.helpers
  update: (data, cb) ->
    Boards.update @_id, data, cb

  addUser: (user, cb) ->
    user = user._id if _.isObject(user)
    @update
      $addToSet:
        users: user
    , cb

  removeUser: (user, cb) ->
    user = user._id if _.isObject(user)
    @update
      $pop:
        users: user
    , cb

  updateName: (name, cb) ->
    @update { $set: {name: name} }, cb

  updateDescription: (desc, cb) ->
    @update { $set: {description: desc} }, cb

  # joins
  getOwner: ->
    UsersCollection.findOne @owner

  getUsers: (options) ->
    UsersCollection.find
      $or: [
        { _id: @owner }
        { _id: { $in: @users } }
      ]
    , options

  getTasks:      (options={sort:{createdAt:-1}}) -> TasksCollection.find { board: @_id }, options
  getTodoTasks:  (options={sort:{createdAt:-1}}) -> TasksCollection.find { board: @_id, state: 'todo'  }, options
  getDoingTasks: (options={sort:{createdAt:-1}}) -> TasksCollection.find { board: @_id, state: 'doing' }, options
  getDoneTasks:  (options={sort:{createdAt:-1}}) -> TasksCollection.find { board: @_id, state: 'done'  }, options

  addTask: (task = {}, cb) ->
    task.board = @_id
    TasksCollection.insert task, cb

  urlData: ->
    id: @_id


# экспорт
@BoardsCollection = Boards
