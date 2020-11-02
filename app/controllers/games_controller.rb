require 'open-uri'
require 'date'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { random_letter }
    @start_time = Time.now
  end
  
  def score

    end_time = Time.now

    @letters = params[:token]
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    score = compute_score(params[:word], end_time -  DateTime.parse(params[:start_time]))
    # raise
  end

  private

  def random_letter
    ('A'..'Z').to_a.sample
  end
  
  def english_word?(word)
    url = open("https://wagon-dictionary.herokuapp.com/#{params[:word].split(/\W+/).join}")
    json = JSON.parse(url.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.split(',').count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
end
