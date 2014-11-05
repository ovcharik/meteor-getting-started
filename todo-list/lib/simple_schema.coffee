# lib/simple_schema.coffee
_.extend SimpleSchema,

  # Данный метод будет из нескольких переданных объектов
  # собирать одну схему и возвращать ее
  build: (objects...) ->
    result = {}
    for obj in objects
      _.extend result, obj
    return new SimpleSchema result

  # Если добавить к схеме данный объект,
  # то у модели появится два поля которые будут автоматически
  # вычисляться
  timestamp:
    createdAt:
      type: Date
      denyUpdate: true
      autoValue: ->
        if @isInsert
          return new Date
        if @isUpsert
          return { $setOnInsert: new Date }
        @unset()

    updatedAt:
      type: Date
      autoValue: ->
        new Date
