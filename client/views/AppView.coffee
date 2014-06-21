class window.AppView extends Backbone.View

  template: _.template '
    <div id="scoreboard">
      <div class="result-container">Game Status: <span>Playing</span></div>
    </div>
    <div>
    <div class="dealer-hand-container"></div>
    <div class="player-hand-container"></div>
    <div id="controls">
      <div><button class="bet-button game-over">Place Your Bet</button></div>
    </div>
  '

  events:
    "click .bet-button": ->
      @model.startGame()
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "click .restart": ->
      $('body').children().remove()
      new AppView(model: new App()).$el.appendTo 'body'

  initialize: ->
    @model.on('change result', =>
      $('.result-container').text("#{@model.get('result')}")
      $('.game-over').toggle()
    )
    @model.on('play', =>
      $('#controls').html('<button class="hit-button game-over">Hit</button> <button class="stand-button game-over">Stand</button>')
    )
    @model.on('gameOver', =>
      $('#controls').html('<button class="restart game-over">Play Again</button>')
    )
    @model.on('bet', =>
      $('#controls').html('<button class="bet-button game-over">Place Your Bet</button>')
    )
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
