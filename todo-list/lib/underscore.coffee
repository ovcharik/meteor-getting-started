_.deepExtend = (target, source) ->
  for prop of source
    if _.isObject(target[prop])
      _.deepExtend target[prop], source[prop]
    else
      target[prop] = source[prop]
  return target
