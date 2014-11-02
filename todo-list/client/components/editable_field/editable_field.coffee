# client/components/editable_field/editable_field.coffee
Template.editableField.helpers
  value: ->
    ObjAndPath.valueFromPath @data, @path

  name: ->
    ObjAndPath.nameFromPath @scope, @path

  hasIcon: ->
    @icon || @iconSymbol

  inputGroupClass: ->
    (@icon || @iconSymbol) && 'input-group' || ''

Template.editableField.events
  # кидаем событие выше, при изменении данных в инпуте
  'change .Field': (event, template) ->
    data  = $(event.target).serializeJSON()
    $(template.firstNode).trigger 'changed', [data]
