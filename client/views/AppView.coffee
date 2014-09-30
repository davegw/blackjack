class window.AppView extends Backbone.View

  betIncrement: 10

  template: _.template '
    <div id="scoreboard">
      <div class="result-container"><%=this.model.get("result")%></div>
    </div>
    <div>
    <div class="dealer-hand-container"></div>
    <div class="player-hand-container"></div>
    <div id="controls">
      <div>
        <button class="bet-decrease">-</button>
        <button class="bet-button game-over">Place Your Bet</button>
        <button class="bet-increase">+</button>
      </div>
    </div>
    <div id="chips">
      <div class="chips-container">Chips: <%=this.model.get("chips")%></div>
      <div class="bet-container">Bet: <%=this.model.get("bet")%></div>
    </div>'

  events:
    "click .bet-button": ->
      @model.set 'result', 'Hit or Stand'
      @model.startGame()

    "click .hit-button": ->
      @model.get('playerHand').hit()

    "click .stand-button": ->
      @model.get('playerHand').stand()

    "click .bet-decrease": ->
      if @model.get('bet') > 0
        @model.set('bet', @model.get('bet') - @betIncrement)

    "click .bet-increase": ->
      if @model.get('bet') + @betIncrement <= @model.get('chips')
        @model.set('bet', @model.get('bet') + @betIncrement)

    "click .restart": ->
      startChips = @model.get 'chips'
      if startChips <= 0 then startChips = 100
      $('body').html(new AppView(model: new App(startChips)).$el)

  initialize: ->
    @model.on('change result', =>
      $('.result-container').text("#{@model.get('result')}")
    )
    @model.on('play', =>
      $('#controls').html('<button class="hit-button game-over">Hit</button> <button class="stand-button game-over">Stand</button>')
    )
    @model.on('end', =>
      $('#controls').html('<button class="restart game-over">Play Again</button>')
    )
    @model.on('change chips', =>
      $('.chips-container').text("Chips: #{@model.get('chips')}")
    )
    @model.on('change bet', =>
      $('.bet-container').text("Bet: #{@model.get('bet')}")
    )
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
