require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    generate_grid
    session[:score] ||= 0 # Initialiser la session score
  end

  def score
    if params[:word]
      @player_word = params[:word]
      @grid = params[:letters]
      grid_array = @grid.split(' ')
      # Préparer la chaîne séparée par des virgules
      @grid_separated = @grid.split.join(',')
      
      if !word_in_grid?(@player_word, grid_array)
        @message = {
          word: @player_word.upcase,
          grid: @grid_separated,
          option: 1
        }
      else
        if !valid_word?(@player_word)
         @message = {
           word: @player_word.upcase,
           option: 2
         }
        else
          @message = {
             word: @player_word.upcase,
             option: 3
           }
           session[:score] += @player_word.length # Incrémenter le score
        end
        
      end
    end
  end

  private

  def generate_grid
    alphabet = ('A'..'Z').to_a
    @letters = 10.times.map { alphabet[rand(alphabet.length)] }
  end
  
  def word_in_grid?(word, grid)
    word_chars = word.upcase.chars
    grid_chars = grid.dup
  
    word_chars.all? do |char|
      index = grid_chars.index(char)
      index && grid_chars.delete_at(index)
    end
  end
  
  def valid_word?(word)
    uri = URI("https://dictionary.lewagon.com/#{word}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    json["found"]
  end
end
