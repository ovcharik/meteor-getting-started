# client/components/editable_field/editable_field.coffee
Template.editableField.helpers
  value: ->
    Blaze._globalHelpers.valueFromPath @data, @path

  name: ->
    Blaze._globalHelpers.nameFromPath @scope, @path

  hasIcon: ->
    @icon || @iconText

  inputGroupClass: ->
    (@icon || @iconText) && 'input-group' || ''

Template.editableField.events
  'change .Field': (event, template) ->
    data  = $(event.target).serializeJSON()
    $(template.firstNode).trigger 'changed', [data]
