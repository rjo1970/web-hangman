describe "A game starts with a word", ->
  When -> @game = new window.Game("word")
  Then -> expect(@game.view()).toEqual ["_","_","_","_"]
  And -> expect(@game.wrongGuessCount()).toEqual 0
  And -> expect(@game.isWon()).toBe false

  describe "A player guesses a letter wrong", ->
    When -> @game.guess("x")
    Then -> expect(@game.guesses()).toEqual ["x"]
    And -> expect(@game.wrongGuessCount()).toEqual 1

    describe "A player tries the same letter twice resulting in no penalty", ->
      When -> @game.guess("x")
      Then -> expect(@game.guesses()).toEqual ["x"]
      And -> expect(@game.wrongGuessCount()).toEqual 1

    describe "losing a game", ->
      When -> @game.guess("y")
      When -> @game.guess("z")
      When -> @game.guess("q")
      When -> @game.guess("u")
      When -> @game.guess("a")
      Then -> expect(@game.isWon()).toBe false
      And -> expect(@game.wrongGuessCount()).toEqual 6
      And -> expect(@game.isOver()).toBe true

      describe "way over-guessing wrong never takes you past 6 guesses", ->
        When -> @game.guess('j')
        Then -> expect(@game.wrongGuessCount()).toEqual 6

  describe "A player guesses a correct letter", ->
    When -> @game.guess("w")
    Then -> expect(@game.guesses()).toEqual ["w"]
    And -> expect(@game.wrongGuessCount()).toEqual 0
    And -> expect(@game.view()).toEqual ["w","_","_","_"]

    describe "winning a game", ->
      When -> @game.guess("o")
      When -> @game.guess("x")
      When -> @game.guess("r")
      When -> @game.guess("d")
      Then -> expect(@game.view()).toEqual ["w","o","r","d"]
      And -> expect(@game.isWon()).toBe(true)
      And -> expect(@game.isOver()).toBe true
