# lib/obj_and_path.coffee
# пара полезных хелперов
@ObjAndPath =
  # находит значение в объекте по указанному пути,
  # вида 'give.me.nested.value'
  valueFromPath: (object = {}, path) ->
    for i in path.split('.')
      object = object[i]
      return null unless object
    object

  # 'give.me.nested.value' -> 'base[give][me][nested][value]'
  nameFromPath: (base, path) ->
    path = path.split('.').join('][')
    path = "[#{path}]" if path
    "#{base}#{path}"
