require "sinatra"
require 'pry'
require 'sinatra/flash'

enable :sessions

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def outcome(player_choice, computer_choice)
  what_wins = { "Rock" => "Scissors", "Scissors" => "Paper", "Paper" => "Rock" }

    if player_choice == computer_choice
       "The result is a tie! No winner this round."
    elsif computer_choice == what_wins[player_choice]
       session[:player_score] += 1
       "PLAYER wins this round."
    elsif player_choice == what_wins[computer_choice]
       session[:computer_score] += 1
       "COMPUTER wins this round."
  end
end

get "/" do

  erb :index
end

post "/" do
  player_choice = params[:choice]
  computer_choice = ["Rock", "Scissors", "Paper"].sample

  flash[:player_choice] = "You chose: #{player_choice}"
  flash[:computer_choice] = "Computer chose: #{computer_choice}"

  flash[:message] = outcome(player_choice, computer_choice)

  if session[:computer_score] == 2
    flash[:alert] = "Computer wins the match! Click an option below to play again."
    session[:visit_count] = nil
  elsif session[:player_score] == 2
    flash[:alert] = "You won the match! Click an option below to play again."
    session[:visit_count] = nil
  end

  if session[:visit_count].nil?
    visit_count = 1
    session[:player_score] = 0
    session[:computer_score] = 0
  else
    visit_count = session[:visit_count]
    player_score = session[:player_score]
    computer_score = session[:computer_score]
  end
    session[:visit_count] = visit_count + 1
    session[:player_score] = player_score + 1
    session[:computer_score] = computer_score + 1

  erb :index

 redirect "/"

end
