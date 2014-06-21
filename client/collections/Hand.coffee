class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop()).last()
    if @scores() > 21
      @trigger('bust')

  stand: ->
    # Trigger stand.
    @trigger('stand')

  scores: ->
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce and (score + 10 <= 21)
      score + 10
    else
      score

  dealerPlay: ->
    @at(0).flip()
    @hit() while @scores() < 17
    @trigger('gameOver')



