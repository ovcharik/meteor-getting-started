# client/components/board_card/board_card.coffee
Template.boardCard.helpers
  panelStyle: ->
    bg = @background?.thumb
    bg && "background-image: url(#{bg})" || ''
