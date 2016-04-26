class Game
  constructor: (@word) ->
    @guessSet = {}

  maxTries: 6

  isInWord: (letter) ->
    @word.indexOf(letter) > -1

  isWon: ->
    self = this
    foundLetters = _.chain(@word.split(""))
    .map((letter) -> self.guessSet[letter])
    .value()
    _.every(foundLetters, _.identity) and @wrongGuessCount() < @maxTries

  isOver: ->
    @isWon() or @wrongGuessCount() == @maxTries

  view: ->
    self = this
    _.chain(@word.split(""))
    .map((letter)-> [letter, self.guessSet[letter]])
    .map((pair)-> if pair[1] or self.isOver() then pair[0] else "_")
    .value()

  guess: (letter) ->
   if !@isOver()
     @guessSet[letter] = @isInWord(letter)

  guesses: ->
    Object.keys(@guessSet)

  wrongGuessCount: ->
    count = _.chain(@guessSet)
    .filter((v)-> v == false)
    .value().length
    Math.min(count, @maxTries)

window.Game = Game

#####################################
# Wireup
#####################################
window.wordlist = ["snow", "tomorrow", "rainbow", "teeny", "seeing",
  "proofread", "bookshelf", "brighten", "nighttime", "skies", "cried",
  "fairies", "shield", "chief", "rice", "officer", "space", "hedge",
  "grudge", "distance"]

window.words = _.shuffle(window.wordlist)

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
