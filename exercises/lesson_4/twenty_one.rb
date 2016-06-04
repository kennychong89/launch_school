# frozen_string_literal: true
# Twenty-One
# Kenny Chong
# 05/30/2016
require 'pry'
SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
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

def calculate_total(cards, total)
  values = cards.map { |card| card[1] }
  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
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
def detect_result(dealer_total, guest_total)
  if busted?(guest_total)
    :guest_busted
  elsif busted?(dealer_total)
    :dealer_busted
  elsif dealer_total < guest_total
    :guest
  elsif dealer_total > guest_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, dealer_total, guest_cards, guest_total)
  result = detect_result(dealer_total, guest_total)

  case result
  when :guest_busted
    prompt "Guest busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :guest
    prompt "Guest win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
  prompt "Guest has #{guest_cards}, for a total of: #{guest_total}"
  puts "=============="
end

def get_winner_name(guest_total, dealer_total)
  result = detect_result(dealer_total, guest_total)
  case result
  when :guest_busted || :dealer
    return "Dealer"
  when :dealer_busted || :guest
    return "Guest"
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
  guest_name = "Guest"
  dealer_name = "Dealer"
  guest_rounds_won = 0
  dealer_rounds_won = 0
  loop do
    winner = play_round(guest_name, dealer_name)
    if winner == guest_name then guest_rounds_won += 1 end
    if winner == dealer_name then dealer_rounds_won += 1 end
    prompt "Rounds Won By #{guest_name}: #{guest_rounds_won}"
    prompt "Rounds Won By #{dealer_name}: #{dealer_rounds_won}"
    break if won_game?(guest_rounds_won) || won_game?(dealer_rounds_won)
    prompt "Press Enter play next round."
    gets.chomp 
    clear_screen
  end
end

def play_round(guest_name, dealer_name)
  deck = initialize_deck
  guest_cards = []
  dealer_cards = []
  guest_total = pre_round_setup(guest_cards, deck)
  dealer_total = pre_round_setup(dealer_cards, deck)
  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "You have: #{guest_cards[0]} and #{guest_cards[1]}, for a total of #{guest_total}."

  guest_total = guest_turn(guest_cards, guest_total, deck)
  if !busted?(guest_total)
    dealer_total = dealer_turn(dealer_cards, dealer_total, deck)
  end
  display_result(dealer_cards, dealer_total, guest_cards, guest_total)
  get_winner_name(guest_total, dealer_total)
end

def pre_round_setup(cards, deck)
  total = 0
  2.times do
    card = deck.pop
    cards << card
    total = calculate_total(cards, total)
  end
  total
end

def guest_turn(guest_cards, guest_total, deck)
  loop do
    choice = hit_or_stay?
    if choice == 'h'
      card = deck.pop
      guest_cards << card
      guest_total = calculate_total(guest_cards, guest_total)
      prompt "You chose to hit!"
      prompt "Your cards are now: #{guest_cards}"
      prompt "Your total is now: #{guest_total}"
    end
    break if choice == 's' || busted?(guest_total) 
  end
  if !busted?(guest_total)
    prompt "Guest stayed at #{guest_total}"
  end
  guest_total
end

def dealer_turn(dealer_cards, dealer_total, deck)
  loop do
    break if busted?(dealer_total) || dealer_total >= 17
    prompt "Dealer hits!"
    card = deck.pop
    dealer_cards << deck.pop
    dealer_total = calculate_total(dealer_cards, dealer_total)
    prompt "Dealer's cards are now: #{dealer_cards}"
  end
  if !busted?(dealer_total)
    prompt "Dealer stayed at #{dealer_total}"
  end
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
