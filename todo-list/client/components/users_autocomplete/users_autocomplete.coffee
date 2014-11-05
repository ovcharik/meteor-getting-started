Template.usersAutocomplete.helpers
  placeholder: ->
    @placeholder || 'Find users'

  search: (q, cb) ->
    Meteor.call 'usersAutocomplete', q, (error, results=[]) ->
      cb _(results).map(UsersCollection._transform)

  selected: (args...) ->
    @data?.selected?.apply(@, args)

  autocompleted: (args...) ->
    @data?.autocompleted?.apply(@, args)


Template.usersAutocomplete.rendered = ->
  Meteor.typeahead @firstNode
  @firstNode.data = @data
