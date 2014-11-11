# collections/tasks.coffee
tasksSchema = SimpleSchema.build SimpleSchema.timestamp,
  'text':
    type: String

  'owner':
    type: String
    autoValue: (doc) ->
      if @isInsert
        return @userId
      if @isUpsert
        return { $setOnInsert: @userId }
      @unset()

  'board':
    type: String
    regEx: SimpleSchema.RegEx.Id

  'state':
    type: String
    allowedValues: ['todo', 'doing', 'done']
    defaultValue: 'todo'

Tasks = new Mongo.Collection 'tasks'
Tasks.attachSchema tasksSchema

if Meteor.isServer
  allow = (userId, doc) ->
    board = BoardsCollection.findOne({ _id: doc.board })
    userId && board && (userId == board.owner || _(board.users).include(userId))

  Tasks.allow
    insert: allow
    remove: allow
    update: (userId, doc, fields) ->
      f = _.intersection(['text', 'state', 'updatedAt'], fields).length == fields.length
      f && allow(userId, doc)

_.extend Tasks,
  findByBoard: (boardId, options) ->
    Tasks.find { board: boardId }, options

Tasks.helpers

  update: (data, cb) ->
    Tasks.update { _id: @_id }, data, cb

  setState: (state, cb) ->
    @update { $set: { state: state } }, cb

  setText: (text, cb) ->
    @update { $set: { text: text } }, cb

  remove: ->
    Tasks.remove { _id: @_id }

  getBoard: ->
    BoardsCollection.findOne { _id: @board }

  getOwner: ->
    BoardsCollection.findOne { _id: @owner }

  isTodo:  -> @state == 'todo'
  isDoing: -> @state == 'doing'
  isDone:  -> @state == 'done'

  toTodo:  -> @setState 'todo'
  toDoing: -> @setState 'doing'
  toDone:  -> @setState 'done'

# export
@TasksCollection = Tasks
