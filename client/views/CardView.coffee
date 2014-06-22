class window.CardView extends Backbone.View
  className: 'card'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html
    @$el.addClass 'covered' unless @model.get 'revealed'
    # Set all uncovered cards to their card image.
    @$el.not('.covered').css({'background-image': "url('img/cards/#{(@model.attributes.rankName).toString().toLowerCase()}-#{(@model.attributes.suitName).toLowerCase()}.png')"})
