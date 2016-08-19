# frozen_string_literal: true
# Twenty-One
# Kenny Chong
# 05/30/2016
require 'pry'
SUITS = ['Clubs', 'Diamonds', 'Hearts', 'Spades'].freeze
VALUES = ['Ace', '2', '3', '4', '5', '6', '7', '9', '10', 'Jack', 'Queen', 'King'].freeze
MAX_SCORE_BEFORE_BUST = 21
MAX_SCORE_BEFORE_DEALER_HOLDS = 17
HIT = '1'
STAY = '2'
WINNING_ROUND_POINT = 5
ACE_RANKING_HIGH = 11
ACE_RANKING_LOW = 1
FACE_RANKING = 10
PAUSE_DURATION = 0.5

def give_card_to(player, card)
  player[:cards].push(card)
end

def set_rounds_won(player, rounds)
  player[:rounds_won] = rounds
end

def set_cards(player, cards)
  player[:cards] = cards
end

def set_score(player, new_total)
  player[:total] = new_total
end

def get_rounds_won(player)
  player[:rounds_won]
end

def get_score(player)
  player[:total]
end

def get_cards(player)
  player[:cards]
end

def get_name(player)
  player[:name] 
end

def update_ranking(card, ranking)
  card[:ranking] = ranking
end

def get_ranking(card)
  card[:ranking]
end

def get_value(card)
  card[:value]
end

def set_value(card, value)
  card[:value] = value
end

def get_suit(card)
  card[:suit]
end

def clear_screen
  system('clear') || system('cls')
end

def prompt(msg)
  puts("=> #{msg}")
end

def create_player(name)
  {name: name, cards: [], total: 0, rounds_won: 0}
end

def initialize_deck
  deck = []
  VALUES.each do |value|
    SUITS.each do |suit|
      card = {value: value, suit: suit, ranking: convert_value_to_ranking(value)}
      deck.push(card)
    end
  end
  deck
end

def convert_value_to_ranking(card_value)
  card_ranking = if card_an_ace?(card_value) 
                   ACE_RANKING_HIGH
                 elsif card_a_face?(card_value) 
                   FACE_RANKING
                 else 
                  card_value.to_i 
                 end
  card_ranking
end

def card_an_ace?(card_value)
  card_value == 'Ace'
end

def card_a_face?(card_value)
  card_value == 'Jack' ||
  card_value == 'Queen' ||
  card_value == 'King'
end

def shuffle_deck(deck)
  deck.shuffle!
end

def deal_cards(player, deck, num_of_cards)
  num_of_cards.times do
    card = deck.shift
    give_card_to(player, card)
  end
end

def busted?(score)
  score > MAX_SCORE_BEFORE_BUST
end

def give_winner_round(winner)
  set_rounds_won(winner, get_rounds_won(winner) + 1) unless winner == nil
end

def valid_choice?(choices, decision)
  choices.include?(decision)
end

def pause_game
  prompt "Press Enter to play next round."
  gets.chomp
end

def game_over(player)
  get_rounds_won(player) == WINNING_ROUND_POINT unless player == nil
end

def fetch_cards_only_with(card_value, cards)
  cards.select { |card| card[:value] == card_value }
end

def fetch_cards_without(card_value, cards)
  cards.select { |card| card[:value] != card_value }
end

def dealer_stays?(dealer, guest)
  (get_score(dealer) >= get_score(guest) \
    && !busted?(get_score(dealer))) \
    || reached_hit_limit?(dealer)
end

def dealer_wins?(dealer, guest)
  busted?(get_score(guest)) || get_score(dealer) > get_score(guest)
end

def reached_hit_limit?(player)
  get_score(player) >= MAX_SCORE_BEFORE_DEALER_HOLDS
end

def display_rounds_won_by(player_one, player_two)
  prompt "Current Rounds Won:"
  prompt "#{get_name(player_one)}: #{get_rounds_won(player_one)}"
  prompt "#{get_name(player_two)}: #{get_rounds_won(player_two)}"
end

def display_player_status(player, show_score)
  if show_score
    prompt "#{get_name(player)}: #{show_cards(get_cards(player))} | Score: #{get_score(player)}"
  else
    prompt "#{get_name(player)}: #{show_cards(get_cards(player))}"
  end
end

def display_previous_card_dealt(player)
  last_card = get_cards(player).last
  prompt "#{get_name(player)} was dealt a #{get_value(last_card)} of #{get_suit(last_card)}."
end

def display_score(player_one, player_two)
  prompt "Score is - #{get_name(player_one)}: #{get_score(player_one)}," \
  "#{get_name(player_two)}: #{get_score(player_two)}" \
end

def display_round_results(player_one, player_two)
  if get_score(player_one) == get_score(player_two) 
    prompt "It's a tie!"
  elsif busted?(get_score(player_one))
    prompt "#{get_name(player_two)} won! #{get_name(player_one)} bust!"
  elsif busted?(get_score(player_two)) 
    prompt "#{get_name(player_one)} won! #{get_name(player_two)} bust!"
  elsif get_score(player_one) > get_score(player_two) 
    prompt "#{get_name(player_one)} won!"
  else 
    prompt "#{get_name(player_two)} won!" 
  end
end

def reset(player_one, player_two)
  set_score(player_one, 0)
  set_score(player_two, 0)
  set_cards(player_one, [])
  set_cards(player_two, [])
end

def calculate_total(cards)
  cards_without_aces = fetch_cards_without('Ace', cards)
  total_without_aces = sum_all(cards_without_aces)
  modify_ace_ranking(cards, total_without_aces)
  sum_all(cards)
end

def sum_all(cards)
  score = 0
  cards.each do |card|
    score += get_ranking(card)
  end
  score
end

def show_cards(cards)
  cards.map do |card|
    card_value = get_value(card)
    if card_an_ace?(card_value) || card_a_face?(card_value)
      card_value + "(#{card[:ranking]})"
    else
      card_value
    end
  end.join(',')
end

def modify_ace_ranking(cards, score)
  updated_score = score
  cards_with_aces = fetch_cards_only_with('Ace', cards)
  
  cards_with_aces.each do |card|
    update_ranking(card, ACE_RANKING_LOW) unless !busted?(updated_score + get_ranking(card))
    updated_score += get_ranking(card)
  end
end

def choose_hit_or_stay
  loop do
    prompt "Press #{HIT} to hit. Press #{STAY} to stay."
    decision = gets.chomp
    return decision unless !valid_choice?([HIT, STAY], decision) 
    prompt "Invalid Choice. Press #{HIT} to hit or #{STAY} to stay."
  end
end

def who_won_round(player_one, player_two)
  player_one_score = get_score(player_one)
  player_two_score = get_score(player_two)
  player_one_wins = (player_one_score > player_two_score) \
                    && !busted?(player_one_score) \
                    || busted?(player_two_score)
  player_two_wins = (player_two_score > player_one_score) \
                    && !busted?(player_two_score) \
                    || busted?(player_one_score)
  winner = if player_one_wins
              player_one   
           elsif player_two_wins
              player_two
           end
  winner
end

def hit(player, deck)
  deal_cards(player, deck, 1)
  player_cards = get_cards(player)
  set_score(player, calculate_total(player_cards))
  display_previous_card_dealt(player)
end

def dealer_turn(dealer, guest, deck)
  prompt "#{get_name(dealer)} TURN"
  loop do
    hit(dealer, deck)
    break if dealer_stays?(dealer, guest)
  end
  display_player_status(dealer, false)
end

def guest_turn(guest, dealer, deck)
  prompt "#{get_name(guest)} TURN"
  loop do
    choice = choose_hit_or_stay
    break unless choice == HIT
    hit(guest, deck)
    display_player_status(guest, true)
    break unless !busted?(get_score(guest))
  end 
end

def pre_round_setup(guest, dealer, deck)
  deal_cards(guest, deck, 2)
  deal_cards(dealer, deck, 2)
  guest_cards = get_cards(guest)
  dealer_cards = get_cards(dealer)

  set_score(guest, calculate_total(guest_cards))
  set_score(dealer, calculate_total(dealer_cards))
  prompt "#{get_name(guest)} has #{show_cards(guest_cards)}"
  prompt "#{get_name(dealer)} has #{show_cards([dealer_cards.first])} and ?"
end

def play_a_round_of_21(guest, dealer)
  deck = shuffle_deck(initialize_deck)

  pre_round_setup(guest, dealer, deck)
  guest_turn(guest, dealer, deck)
  if !dealer_wins?(dealer, guest) || !reached_hit_limit?(dealer)
    dealer_turn(dealer, guest, deck)
  end 
  display_round_results(guest, dealer)
  display_score(guest, dealer)
end

def run_game_loop
  guest = create_player("Guest")
  dealer = create_player("Dealer")
  loop do
    play_a_round_of_21(guest, dealer)
    winner = who_won_round(guest, dealer)
    give_winner_round(winner) 
    display_rounds_won_by(guest, dealer)
    break if game_over(winner)
    pause_game
    reset(guest, dealer)
    clear_screen
  end
  display_rounds_won_by(guest, dealer)
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

run_game_loop