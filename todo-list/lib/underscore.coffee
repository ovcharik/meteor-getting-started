_.deepExtend = (target, source) ->
  for prop of source
    if prop in target
      _.deepExtend target[prop], source[prop]
    else
      target[prop] = source[prop]
  return target
