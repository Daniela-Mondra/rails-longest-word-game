require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    generate_grid
  end

  def score
    @word = params[:input].upcase
    @grid = params[:grid].split('')
    @valid_word = valid_word?(@word, @grid)
    @english_word = english_word?(@word)

    if !@valid_word
      @result = "The word #{@word} cannot be built out of #{@grid.join(', ')}."
    elsif !@english_word
      @result = "The word #{@word} is valid according to the grid, but it is not a valid English word."
    else
      @result = "Congratulations! #{@word} is a valid English word."
    end
  end

  private

  def generate_grid
    alphabet = ("A".."Z").to_a
    @letters = Array.new(10) { alphabet.sample }
  end

  def valid_word?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    search = JSON.parse(URI.open("https://dictionary.lewagon.com/#{word}").read)
    search['found']
  end
end
