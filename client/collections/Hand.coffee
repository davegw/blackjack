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

  scores: (peek=false) ->
    hasAce = @reduce (memo, card) ->
      memo or ((card.get('revealed') or peek) and (card.get('value') is 1))
    , false
    score = @reduce (score, card) ->
      newCard
      if (card.get('revealed') or peek)
        newCard = card.get 'value'
      else
        newCard = 0
      score + newCard
    , 0
    if hasAce and (score + 10 <= 21)
      score + 10
    else
      score

  dealerPlay: ->
    @at(0).flip()
    @hit() while @scores() < 17
    @trigger('gameOver')

  startHand: ->
    if @isDealer
      @at(1).flip()
    else
      @at(0).flip()
      @at(1).flip()

  checkBlackJack: ->
    if @scores(true) == 21
      true
    else
      false


