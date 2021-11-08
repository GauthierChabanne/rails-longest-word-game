require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    voyelles = ["A", "E", "I", "O", "U"]
    7.times do
      @letters << ('A'..'Z').to_a.sample
    end
    3.times do
      @letters << voyelles.sample
    end
  end

  def score
    @letters = params[:letters]
    @answer = params[:answer]
    @initial_score = scoring(@answer)
    @result = run_game(@answer, @letters)
    # @score = @initial_score + params[:score]
    # raise
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    if !valid_answer?(attempt, grid)
      result = 1
    elsif !valid?(attempt)
      result = 2
    else
      result = 3
    end
    result
  end

  def valid_answer?(attempt, grid)
    attempt.upcase.chars.all? do |letter|
      grid.include?(letter) && attempt.upcase.count(letter) <= grid.count(letter)
    end
  end

  def valid?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def scoring(attempt)
    score = attempt.length
    Math.sqrt(score).round(2)
  end
end
