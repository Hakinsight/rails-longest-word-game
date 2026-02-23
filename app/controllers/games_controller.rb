require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word].upcase
    @grid = params[:letters].split(" ")

    url = "https://dictionary.lewagon.com/#{@word}"
    # Le bloc begin/rescue permet d'éviter que le site crash si l'API est hors-ligne
    begin
      response = URI.open(url).read
      user = JSON.parse(response)
      english_word = user["found"]
    rescue
      english_word = false # Si l'API ne répond pas, on considère le mot invalide
    end

    if !included?(@word, @grid)
      @result = "Désolé, mais #{@word} ne peut pas être fait à partir de #{@grid.join(', ')}"
    elsif !english_word
      @result = "Désolé, mais #{@word} n'est pas un mot anglais valide..."
    else
      @result = "Félicitations ! #{@word} est un mot anglais valide !"
    end
  end

  private

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
end
