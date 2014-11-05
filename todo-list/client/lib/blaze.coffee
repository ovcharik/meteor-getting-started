# описываем хелперы, которые будут доступны во всех шаблонах
helpers =
  valueFromPath: (object = {}, path) ->
    ObjAndPath.valueFromPath(object, path)

  nameFromPath: (base, path) ->
    ObjAndPath.valueFromPath(base, path)

  isHomePage: ->
    Router.current() instanceof HomeController

# добавляем хелперы в Blaze
_(helpers).map (value, key) -> Blaze.registerHelper(key, value)
