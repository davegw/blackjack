#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'result', 'Playing'

    # Listens for stand
    (@get 'playerHand').on('stand', =>
      (@get 'dealerHand').dealerPlay()
    )
    (@get 'playerHand').on('bust', =>
      @bust()
    )

    # Listen for game over event
    (@get 'dealerHand').on('gameOver', =>
      @gameOver()
    )

  # Determine winner
  gameOver: ->
    playerScore = (@get 'playerHand').scores()[0]
    dealerScore = (@get 'dealerHand').scores()[0]
    console.log('player: ', playerScore)
    console.log(dealerScore)
    if dealerScore > 21 or playerScore > dealerScore
      @set 'result', "You Win"
    else if playerScore == dealerScore
      @set 'result', "Push"
    else
      @set 'result', "You Lose"

  bust: ->
    @set 'result', "Bust"
