class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button game-over">Hit</button> <button class="stand-button game-over">Stand</button>
    <button class="restart game-over">Restart Game</button>
    <div class="result-container">Game Status: <span>Playing</span></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
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
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
