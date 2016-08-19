# frozen_string_literal: true
# Twenty-One
# Kenny Chong
# 05/30/2016
require 'pry'
SUITS = ['H', 'D', 'S', 'C'].freeze
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze
MAX_SCORE_BEFORE_BUST = 21
MAX_SCORE_BEFORE_DEALER_HOLDS = 17
WINNING_ROUND_POINT = 5

def clear_screen
  system('clear') || system('cls')
end

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def calculate_total(cards)
  values = cards.map { |card| card[1] }
  sum = 0
  values.each do |value|
    sum += if value == 'A'
             11
           elsif value.to_i == 0
             10
           else
             value.to_i
           end
  end
  correct_for_aces(cards, sum)
end

def correct_for_aces(cards, sum)
  cards.select { |card| card[1] == "A" }.count.times do
    sum -= 10 if sum > 21
  end
  sum
end

def busted?(total)
  total > 21
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_total, player_total)
  if busted?(player_total)
    :player_busted
  elsif busted?(dealer_total)
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def displayer_winner(result)
  case result
  when :player_busted
    prompt "Player busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "Player win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def display_result(dealer_cards, dealer_total, player_cards, player_total)
  result = detect_result(dealer_total, player_total)
  displayer_winner(result)
  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
  prompt "Player has #{player_cards}, for a total of: #{player_total}"
  puts "=============="
end

def get_winner_name(player_total, dealer_total)
  result = detect_result(dealer_total, player_total)
  if result == :player_busted || result == :dealer
    return "Dealer"
  elsif result == :dealer_busted || result == :player
    return "Player"
  end
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def start_game
  prompt "Let's play 21!"
  loop do
    run_game_loop
    prompt "Do you want to play again? ('y' or 'n')."
    decision = gets.chomp
    break unless decision.downcase.start_with?('y')
  end
  prompt "Thank you for playing! Goodbye!"
end

def run_game_loop
  player_rounds_won = 0
  dealer_rounds_won = 0
  loop do
    winner = play_round
    if winner == "Player" then player_rounds_won += 1 end
    if winner == "Dealer" then dealer_rounds_won += 1 end
    prompt "Rounds Won By Player: #{player_rounds_won}"
    prompt "Rounds Won By Dealer: #{dealer_rounds_won}"
    break if won_game?(player_rounds_won) || won_game?(dealer_rounds_won)
    prompt "Press Enter play next round."
    gets.chomp
    clear_screen
  end
end

def play_round
  deck = initialize_deck
  player_cards = []
  dealer_cards = []
  player_total = pre_round_setup(player_cards, deck)
  dealer_total = pre_round_setup(dealer_cards, deck)
  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "Player has: #{player_cards[0]} and #{player_cards[1]}, for a total of #{player_total}."

  player_total = player_turn(player_cards, player_total, deck)
  if !busted?(player_total)
    dealer_total = dealer_turn(dealer_cards, dealer_total, deck)
  end
  display_result(dealer_cards, dealer_total, player_cards, player_total)
  get_winner_name(player_total, dealer_total)
end

def pre_round_setup(cards, deck)
  total = 0
  2.times do
    card = deck.pop
    cards << card
    total = calculate_total(cards)
  end
  total
end

def player_turn(player_cards, player_total, deck)
  loop do
    choice = hit_or_stay?
    if choice == 'h'
      card = deck.pop
      player_cards << card
      player_total = calculate_total(player_cards)
      prompt "Player chose to hit!"
      prompt "Player cards are now: #{player_cards}"
      prompt "Player total is now: #{player_total}"
    end
    break if choice == 's' || busted?(player_total)
  end
  if !busted?(player_total) then prompt("Player stayed at #{player_total}") end
  player_total
end

def dealer_turn(dealer_cards, dealer_total, deck)
  loop do
    break if busted?(dealer_total) || dealer_total >= 17
    prompt "Dealer hits!"
    dealer_cards << deck.pop
    dealer_total = calculate_total(dealer_cards)
    prompt "Dealer's cards are now: #{dealer_cards}"
  end
  if !busted?(dealer_total) then prompt("Dealer stayed at #{dealer_total}") end
  dealer_total
end

def hit_or_stay?
  guest_turn = ''
  loop do
    prompt "Would you like to (h)it or (s)tay?"
    guest_turn = gets.chomp.downcase
    break if ['h', 's'].include?(guest_turn)
    prompt "Sorry, must enter 'h' or 's'."
  end
  guest_turn
end

def won_game?(winner_rounds)
  winner_rounds == WINNING_ROUND_POINT
end

start_game
