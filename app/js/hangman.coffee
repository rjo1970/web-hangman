class Game
  constructor: (@word) ->
    @guessSet = {}

  maxTries: 6

  view: ->
    self = this
    _.chain(@word.split(""))
    .map((letter)-> [letter, self.guessSet[letter]])
    .map((pair)-> if pair[1] then pair[0] else "_")
    .value()

  isInWord: (letter) ->
    @word.indexOf(letter) > -1

  guess: (letter) ->
    @guessSet[letter] = @isInWord(letter)

  guesses: ->
    Object.keys(@guessSet)

  wrongGuessCount: ->
    count = _.chain(@guessSet)
    .filter((v)-> v == false)
    .value().length
    Math.min(count, @maxTries)

  isWon: ->
    @view().indexOf("_") == -1 and @wrongGuessCount() < @maxTries

  isOver: ->
    @isWon() or @wrongGuessCount() == @maxTries

window.Game = Game

#####################################
# Wireup
#####################################

window.words = _.shuffle(["rooftop", "food", "toolbox", "boom", "gloomy", "spoonful", "soon", "scoop", "hoot", "poor", "wood", "soot", "football", "droop", "scooter", "proofread", "bookshelf", "gooey", "loop", "noodle"])

window.game = new Game(window.words[0])

window.show = ->
  html = JST["app/templates/guesses.us"](
    view: window.game.view()
    guesses: window.game.guesses()
    guessCount: window.game.wrongGuessCount()
    youWin: window.game.isWon()
    gameOver: window.game.isOver()
  )
  $('#content').html(html)

window.keydownAction = (event)->
  guess = String.fromCharCode(event.which)
  window.game.guess(guess.toLowerCase())
  window.show()

$(->
  window.show()
  $('body').keydown(window.keydownAction)
)
