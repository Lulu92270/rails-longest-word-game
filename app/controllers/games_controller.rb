require 'json'
require 'open-uri'
require 'date'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do 
      @letters << many_votes
    end
    @start_time = Time.now
  end
  
  def score

    end_time = Time.now

    # raise
    # RestClient - restart server

  if english_word?(params[:word])
    if included?(params[:word], params[:token])
      score = compute_score(params[:word], end_time -  DateTime.parse(params[:start_time]))
      @result = "Congratulations! #{params[:word]} is a valid English word! Score: #{score}"

    else
      @result = "Sorry but #{params[:word]} can't be built out of #{params[:token]}"
    end
  else
    @result = "Sorry but #{params[:word]} doesn't seem to be a valid English word..."
  end
end

  private

  def many_votes
    ('A'..'Z').to_a.sample
  end
  
  def english_word?(word)
    url = open("https://wagon-dictionary.herokuapp.com/#{params[:word].split(/\W+/).join}")
    json = JSON.parse(url.read)
    return json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.split(',').count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
end
