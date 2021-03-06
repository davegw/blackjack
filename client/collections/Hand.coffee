class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop()).last()
    @trigger 'bust' if @scores() > 21

  stand: ->
    @trigger 'stand'

  # Set peek to true to count unrevealed cards.
  scores: (peek=false) ->
    hasAce = @reduce (memo, card) ->
      memo or ((card.get('revealed') or peek) and (card.get('value') is 1))
    , false
    score = @reduce (score, card) ->
      if (card.get('revealed') or peek)
        newCard = card.get 'value'
      else
        newCard = 0
      score + newCard
    , 0
    # Determines the proper value if there is an ace.
    if hasAce and (score + 10 <= 21)
      score + 10
    else
      score

  # Dealer auto-play function.
  dealerPlay: ->
    @at(0).flip()
    @hit() while @scores() < 17
    @trigger 'gameOver'

  # Reveal cards to start the hand.
  startHand: ->
    if @isDealer
      @at(1).flip()
    else
      @at(0).flip()
      @at(1).flip()

  checkBlackJack: ->
    if @scores(true) == 21 then true else false
