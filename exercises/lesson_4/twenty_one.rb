# frozen_string_literal: true
# Twenty-One
# Kenny Chong
require 'pry'
SUITS = ['Clubs', 'Diamonds', 'Hearts', 'Spades'].freeze
VALUES = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King'].freeze
MAX_SCORE_BEFORE_BUST = 21
MAX_SCORE_BEFORE_DEALER_HOLDS = 17
PLAYER_NAME = "Player"
DEALER_NAME = "Dealer"
HIT = '1'
STAY = '2'
INITIAL_CARDS_TO_DRAW = 2
WINNING_ROUND_POINT = 5
ACE_RANKING_HIGH = 11
ACE_RANKING_LOW = 1
FACE_RANKING = 10
PAUSE_DURATION = 0.5

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

def prompt(msg)
  puts("=> #{msg}")
end

def run_game_loop
  rounds_won_card = { PLAYER_NAME => 0, DEALER_NAME => 0 }
  rounds = 1
  loop do
    prompt "ROUND #{rounds}"
    winner_name = play_a_round_of_21
    if there_is_winner(winner_name)
      give_winner_a_round_point(rounds_won_card, winner_name)
      break if game_over(rounds_won_card, winner_name)
    end
    rounds += 1
    display_round_scores(rounds_won_card)
    prompt "Press Enter to play next round."
    gets.chomp
    clear_screen
  end
  display_round_scores(rounds_won_card)
end

def play_a_round_of_21
  deck = create_deck_and_shuffle
  player_hand = create_hand(INITIAL_CARDS_TO_DRAW, deck)
  dealer_hand = create_hand(INITIAL_CARDS_TO_DRAW, deck)
  score_tracker = { PLAYER_NAME => 0, DEALER_NAME => 0 }
  update_score(score_tracker, PLAYER_NAME, calculate_hand(player_hand))
  update_score(score_tracker, DEALER_NAME, calculate_hand(dealer_hand))
  display_person_hand_and_score(player_hand, PLAYER_NAME, score_tracker)
  display_person_hand_and_score(dealer_hand, DEALER_NAME, score_tracker)
  player_turn(player_hand, dealer_hand, score_tracker, deck)
  dealer_turn(dealer_hand, player_hand, score_tracker, deck)
  display_round_results(score_tracker)
  get_winner_name(score_tracker) unless tied?(score_tracker)
end

def create_deck_and_shuffle
  VALUES.product(SUITS).shuffle!
end

def create_hand(cards_to_draw, deck)
  hand = []
  cards_to_draw.times do
    card = draw_card!(deck)
    add_card_to_hand(hand, card)
  end
  hand
end

def add_card_to_hand(hand, card)
  hand.push(card)
end

def draw_card!(deck)
  deck.shift
end

def calculate_hand(hand)
  score = 0
  hand.each do |card|
    card_ranking = get_card_ranking(card)
    score += card_ranking
  end

  if busted?(score) && how_many_aces_in_hand?(hand) > 0
    score = adjust_score_for_aces(hand, score)
  end
  score
end

def get_card_ranking(card)
  card_value = get_card_value(card)
  card_ranking = if card_is_an_ace_value?(card_value)
                   ACE_RANKING_HIGH
                 elsif card_is_a_face_value?(card_value)
                   FACE_RANKING
                 else
                   convert_card_value_to_its_numerical_ranking(card_value)
                 end
  card_ranking
end

def get_card_value(card)
  card[0]
end

def card_is_an_ace_value?(card_value)
  card_value == 'Ace'
end

def card_is_a_face_value?(card_value)
  card_value == 'Jack' ||
    card_value == 'Queen' ||
    card_value == 'King'
end

def convert_card_value_to_its_numerical_ranking(card_value)
  card_value.to_i
end

def busted?(score)
  score > MAX_SCORE_BEFORE_BUST
end

def how_many_aces_in_hand?(hand)
  hand.each.select do |card|
    card_is_an_ace_value?(get_card_value(card))
  end.count
end

def adjust_score_for_aces(hand, score)
  updated_score = score
  points_to_deduct = ACE_RANKING_HIGH - ACE_RANKING_LOW
  how_many_aces_in_hand?(hand).times do
    updated_score -= points_to_deduct unless !busted?(updated_score)
  end
  updated_score
end

def update_score(score_tracker, person_name, new_score)
  score_tracker[person_name] = new_score
end

def player_turn(player_hand, dealer_hand, score_tracker, deck)
  prompt "#{PLAYER_NAME} TURN"
  loop do
    decision = ask_player_to_choose_an_option
    break unless decision == HIT
    deal(player_hand, PLAYER_NAME, score_tracker, deck)
    display_person_hand_and_score(player_hand, PLAYER_NAME, score_tracker)
    display_person_hand_and_score(dealer_hand, DEALER_NAME, score_tracker)
    prompt "\n"
    break unless !busted?(get_score(score_tracker, PLAYER_NAME))
  end
end

def ask_player_to_choose_an_option
  decision = ''
  loop do
    prompt "Press #{HIT} to hit. Press #{STAY} to stay."
    decision = gets.chomp
    break unless decision != HIT && decision != STAY
    prompt "Invalid Choice. Press #{HIT} to hit or #{STAY} to stay."
  end
  decision
end

def deal(hand, name, score_tracker, deck)
  invoke_delay_when_drawing_a_card
  card = draw_card!(deck)
  add_card_to_hand(hand, card)
  update_score(score_tracker, name, calculate_hand(hand))
  display_person_name_and_card_drawn(name, card)
end

def invoke_delay_when_drawing_a_card
  prompt "Drawing a card..."
  sleep(PAUSE_DURATION)
end

def display_person_name_and_card_drawn(name, card)
  prompt "#{name}: Drew a #{get_card_value(card)} of #{get_card_suit(card)}."
end

def display_person_hand_and_score(hand, name, score_tracker)
  prompt "#{name}: #{show_cards_in_hand(hand)} | Score: #{score_tracker[name]}"
end

def show_cards_in_hand(hand)
  hand.map do |card|
    card_value = get_card_value(card)
    card_ranking = get_card_ranking(card)
    if card_is_an_ace_value?(card_value) || card_is_a_face_value?(card_value)
      card_value + "(#{card_ranking})"
    else
      get_card_value(card)
    end
  end.join(', ')
end

def get_score(score_tracker, person_name)
  score_tracker[person_name]
end

def dealer_wins?(score_tracker)
  player_score = get_score(score_tracker, PLAYER_NAME)
  dealer_score = get_score(score_tracker, DEALER_NAME)
  busted?(player_score) || dealer_score > player_score
end

def dealer_turn(dealer_hand, player_hand, score_tracker, deck)
  dealer_score = get_score(score_tracker, DEALER_NAME)
  return unless !dealer_wins?(score_tracker) && !dealer_reached_hit_limit?(dealer_score)
  prompt "#{DEALER_NAME} TURN"
  loop do
    deal(dealer_hand, DEALER_NAME, score_tracker, deck)
    display_person_hand_and_score(player_hand, PLAYER_NAME, score_tracker)
    display_person_hand_and_score(dealer_hand, DEALER_NAME, score_tracker)
    prompt "\n"
    break unless !dealer_stops?(score_tracker) && !busted?(dealer_score)
  end
end

def dealer_stops?(score_tracker)
  player_score = get_score(score_tracker, PLAYER_NAME)
  dealer_score = get_score(score_tracker, DEALER_NAME)
  dealer_score >= player_score || dealer_reached_hit_limit?(dealer_score)
end

def dealer_reached_hit_limit?(dealer_score)
  dealer_score >= MAX_SCORE_BEFORE_DEALER_HOLDS
end

def display_round_results(score_tracker)
  player_score = get_score(score_tracker, PLAYER_NAME)
  dealer_score = get_score(score_tracker, DEALER_NAME)
  prompt "Final score is - #{PLAYER_NAME}: #{player_score}, #{DEALER_NAME}: #{dealer_score}"
  if player_score == dealer_score
    prompt "It's a tie!"
  elsif busted?(dealer_score)
    prompt "#{PLAYER_NAME} have won! #{DEALER_NAME} has busted."
  elsif busted?(player_score)
    prompt "#{DEALER_NAME} has won! #{PLAYER_NAME} has busted"
  elsif dealer_score > player_score
    prompt "#{DEALER_NAME} has won!"
  else
    prompt "#{PLAYER_NAME} have won!"
  end
  prompt "\n"
end

def tied?(score_tracker)
  score_tracker[PLAYER_NAME] == score_tracker[DEALER_NAME]
end

def get_winner_name(score_tracker)
  if dealer_wins?(score_tracker)
    return DEALER_NAME
  end
  PLAYER_NAME
end

def give_winner_a_round_point(rounds_won_card, winner_name)
  rounds_won_card[winner_name] += 1
end

def there_is_winner(winner_name)
  !!winner_name
end

def game_over(rounds_won_card, winner_name)
  rounds_won_card[winner_name] == WINNING_ROUND_POINT
end

def display_round_scores(rounds_card)
  prompt "Current Rounds Won:"
  rounds_card.each do |name, score|
    prompt "#{name}: #{score}"
  end
end

def clear_screen
  system('clear') || system('cls')
end

def get_card_suit(card)
  card[1]
end

start_game
