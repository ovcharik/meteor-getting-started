# client/components/next_page_button/next_page_button.coffee
Template.nextPageButton.helpers
  loaded: ->
    ctrl = Router.current()
    if ctrl.pageable
      ctrl.loaded(@name)
    else
      true

Template.nextPageButton.events
  'click .NextPageButton': (event) ->
    ctrl = Router.current()
    if ctrl.pageable
      ctrl.incLimit(@name, @perPage)
