#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    # Listens for stand
    (@get 'playerHand').on('stand', =>
      (@get 'dealerHand').dealerPlay()
    )
    # Listen for game over event
    (@get 'dealerHand').on('gameOver', =>
      @gameOver()
    )

  # Determine winner
  gameOver: ->
    playerScore = (@get 'playerHand').scores()
    dealerScore = (@get 'dealerHand').scores()
    if playerScore > dealerScore
      alert 'player wins'
    else if playerScore == dealerScore
      alert 'push'
    else
      alert 'dealer wins'
