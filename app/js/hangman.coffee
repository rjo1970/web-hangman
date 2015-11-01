class Game
  constructor: (@word) ->
    @guessSet = {}

  maxTries: 6

  view: ->
    guesses = @guesses()
    @word.split("").
    map((letter)->
      if guesses.indexOf(letter) > -1 then letter else "_")

  guess: (letter) ->
    @guessSet[letter] = @word.indexOf(letter)

  guesses: ->
    Object.keys(@guessSet)

  wrongGuessCount: ->
    guessSet = @guessSet
    @guesses().map((letter)->
      guessSet[letter]
    ).filter((x)->
      x == -1
    ).length

  isWon: ->
    @guesses().indexOf("_") == -1 and @wrongGuessCount() < @maxTries

  isOver: ->
    @isWon() or @wrongGuessCount() >= @maxTries

window.Game = Game
