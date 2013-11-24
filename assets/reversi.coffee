
forDir = (fn) ->
  fn 1, 0
  fn 1, -1
  fn 0, -1
  fn -1, -1
  fn -1, 0
  fn -1, 1
  fn 0, 1
  fn 1, 1

class Reversi
  constructor: (selector) ->
    @el = document.querySelector selector
    @el.classList.add 'reversi-board'
    @resetGame()
  resetGame: ->
    @currentPlayer = 0
    @board = [1..8].map -> [1..8].map -> null
    @updateCells()
    @setCoin 3, 3, 0
    @setCoin 4, 3, 1
    @setCoin 4, 4, 0
    @setCoin 3, 4, 1
    document.querySelector('#status').innerText = 'Black should make a move'
  updateCells: ->
    @el.innerHTML = ''
    @cells = @board.map (row, y) =>
      div = document.createElement 'div'
      div.className = 'reversi-row'
      @el.appendChild div
      return row.map (cell, x) =>
        c = document.createElement 'div'
        c.innerHTML = '<div class="reversi-coin"></div>'
        c.className = 'reversi-cell'
        c.addEventListener (if hasTouchSupport then 'touchstart' else 'click'), =>
          # @emit 'click', { x: x, y: y, player: @currentPlayer }
          @placeCoin x, y
        div.appendChild c
        return c
  setCoin: (x, y, player) ->
    @board[y][x] = player
    @cells[y][x].className = 'reversi-cell reversi-coin-' + player
  flipCoin: (x, y) ->
    @setCoin x, y, @currentPlayer
  placeCoin: (x, y) ->
    if @board[y][x] isnt null
      return
    flipped = 0
    forDir (dx, dy) =>
      cx = x + dx
      cy = y + dy
      arr = []
      while 1
        if cx < 0 or cx >= 8 or cy < 0 or cy >= 8
          break
        p = @board[cy][cx]
        if p is null
          break
        if p is @currentPlayer
          flipped += arr.length
          arr.forEach ([x, y]) => @flipCoin x, y
          break
        else
          arr.push [cx, cy]
          cx += dx
          cy += dy
    if flipped
      @flipCoin x, y
      @currentPlayer = (@currentPlayer + 1) % 2
      if @currentPlayer
        document.querySelector('#status').innerText = 'White should make a move'
      else
        document.querySelector('#status').innerText = 'Black should make a move'

window.Reversi = Reversi
