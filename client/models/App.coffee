class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'result', 'Playing'

    # Listens for stand.
    (@get 'playerHand').on('stand', =>
      (@get 'dealerHand').dealerPlay()
      @trigger 'end'
    )

    # Listen for bust.
    (@get 'playerHand').on('bust', =>
      @bust()
      @trigger 'end'
    )

    # Listen for game over event.
    (@get 'dealerHand').on('gameOver', =>
      @gameOver()
      @trigger 'end'
    )

  # Start the game.
  startGame: ->
    @get('playerHand').startHand()
    @get('dealerHand').startHand()
    # Handle blackjacks.
    if @get('playerHand').checkBlackJack()
      if @get('dealerHand').checkBlackJack()
        @set 'result', "Push"
      else
        @blackJack()
      @get('dealerHand').at(0).flip()
      @trigger 'end'
    else if @get('dealerHand').checkBlackJack()
      @set 'result', "Dealer BlackJack! You Lose"
      @get('dealerHand').at(0).flip()
      @trigger 'end'
    # Play the hand if there are no blackjacks.
    else
      @trigger('play')

  # Determine winner
  gameOver: ->
    playerScore = (@get 'playerHand').scores()
    dealerScore = (@get 'dealerHand').scores()
    if dealerScore > 21 or playerScore > dealerScore
      @set 'result', "You Win!"
    else if playerScore == dealerScore
      @set 'result', "Push"
    else
      @set 'result', "You Lose"

  bust: ->
    @set 'result', "Bust! You Lose."
    @get('dealerHand').at(0).flip()

  blackJack: ->
    @set 'result', "BlackJack!!! You Win!"
