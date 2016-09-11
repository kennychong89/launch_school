# frozen_string_literal: true
# Launch School
# Lesson 5: Twenty One OOP
# Kenny Chong
# 09/10/2016 9:24 PM

require 'pry'
class Card
  SUITS = { 'H' => 'Heart',
            'D' => 'Diamond',
            'S' => 'Spade',
            'C' => 'Club' }.freeze
  NAMES = { 'A' => 'Ace', '2' => 'Two', '3' => 'Three',
            '4' => 'Four', '5' => 'Five', '6' => 'Six',
            '7' => 'Seven', '8' => 'Eight', '9' => 'Nine',
            '10' => 'Ten', 'J' => 'Jack', 'Q' => 'Queen', 'K' => 'King' }.freeze
  attr_accessor :reveal, :value
  attr_reader :suit, :name

  def initialize(suit, name, value, reveal = true)
    @suit = suit
    @name = name
    @value = value
    @reveal = reveal
  end

  def self.num_value(card_name)
    if card_name == 'J' || card_name == 'Q' || card_name == 'K'
      10
    elsif card_name == 'A'
      11
    else
      card_name.to_i
    end
  end

  def fancy_description
    "#{Card::NAMES[@name]} of #{Card::SUITS[@suit]}"
  end

  def to_s
    "#{@name}#{@suit}"
  end
end

class Deck
  def initialize
    @deck = create_deck
    @cards_drawn = 0
  end

  def size
    @deck.length
  end

  def cards_remaining
    size - @cards_drawn
  end

  def shuffle
    @deck.shuffle!
  end

  def put_back_cards
    @cards_drawn = 0
    reset_ace_values
  end

  def draw_a_card
    card = nil
    if cards_remaining != 0
      card = @deck[@cards_drawn]
      @cards_drawn += 1
    end
    card
  end

  private

  def create_deck
    deck = []
    Card::NAMES.keys.each do |name|
      Card::SUITS.keys.each do |suit|
        deck.push(Card.new(suit, name, Card.num_value(name)))
      end
    end
    deck
  end

  def reset_ace_values
    @deck.select { |card| card.name == "A" }.each { |ace| ace.value = 11 }
  end
end

class Participant
  attr_reader :name, :cards_in_hand, :hand_total, :score

  def initialize(name)
    @name = name
    @hand = []
    @cards_in_hand = 0
    @hand_total = 0
    @score = 0
  end

  def award(points)
    @score += points
  end

  def reset_score
    @score = 0
  end

  def add_to_hand(card)
    @hand.push(card)
    @cards_in_hand += 1
    @hand_total += card.value
    correct_for_aces if Rules.busted?(@hand_total)
  end

  def reveal_hand
    @hand.each do |card|
      card.reveal = true
    end
  end

  def empty_hand
    @hand = []
    @cards_in_hand = 0
    @hand_total = 0
  end

  def show_hand
    cards = @hand.map { |card| card.reveal ? card : "?" }
    cards.join(',') unless cards_in_hand == 0
  end

  private

  def correct_for_aces
    aces_to_reduce = 0
    aces_hand = @hand.select { |card| card.name == "A" && card.value == 11 }
    aces_hand.count.times do
      if Rules.busted?(@hand_total)
        @hand_total -= 10
        aces_to_reduce += 1
      end
    end

    aces_hand.each do |card|
      if aces_to_reduce > 0
        card.value = 1
        aces_to_reduce -= 1
      end
    end
  end
end

class Dealer < Participant
  HIT_LIMIT = 17

  def turn(deck)
    until Rules.busted?(hand_total) || reached_hit_limit?
      card = deck.draw_a_card
      add_to_hand(card)
      puts "#{name} has drawn an #{card.fancy_description}"
      puts "#{name}: #{show_hand} (total:#{hand_total})"
    end
  end

  private

  def reached_hit_limit?
    hand_total >= HIT_LIMIT
  end
end

class Player < Participant
  def turn(deck)
    until Rules.busted?(hand_total) || !hit?
      card = deck.draw_a_card
      add_to_hand(card)
      puts "#{name} has drawn an #{card.fancy_description}"
      puts "#{name}: #{show_hand} (total:#{hand_total})"
    end
  end

  private

  def hit?
    decision = nil
    loop do
      puts "Press h to hit or press s to stay?"
      decision = gets.chomp.downcase

      break if %w(h s).include? decision
      puts "Invalid input."
    end

    return true if decision == 'h'
  end
end

class Rules
  BUST_LIMIT = 21
  attr_reader :player, :dealer

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
  end

  def self.busted?(total)
    total > BUST_LIMIT
  end

  def results
    if winner.nil? && loser.nil?
      puts "It's a tie!"
    elsif Rules.busted?(loser.hand_total)
      puts "#{loser.name} has busted!"
    end
    puts "#{winner.name} is the winner!" unless winner.nil?
  end

  def winner
    return winner_by_bust unless winner_by_bust.nil?
    return winner_by_total unless winner_by_total.nil?
  end

  def winner_by_bust
    if Rules.busted?(player.hand_total)
      dealer
    elsif Rules.busted?(dealer.hand_total)
      player
    end
  end

  def winner_by_total
    if player.hand_total > dealer.hand_total
      player
    elsif dealer.hand_total > player.hand_total
      dealer
    end
  end

  def loser
    unless winner.nil?
      winner.name == dealer.name ? player : dealer
    end
  end
end

class Round
  MATCH_POINT = 5
  attr_reader :player, :dealer, :deck, :rules

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
    @deck = Deck.new
    @deck.shuffle
    @rules = Rules.new(@player, @dealer)
  end

  def play
    loop do
      display_score
      setup
      turn
      results
      rules.winner.award(1) if !!rules.winner
      break if game_over?
      continue
      reset
    end
  end

  def reset
    player.empty_hand
    dealer.empty_hand
    deck.put_back_cards
    deck.shuffle
    TwentyOne.clear_screen
  end

  private

  def continue
    puts "Press any key to start next game."
    gets.chomp
  end

  def turn
    player_turn
    dealer_turn if !Rules.busted?(player.hand_total)
  end

  def player_turn
    puts "=== Player's turn (#{player.name}) ==="
    player.turn(deck)
    puts ""
  end

  def dealer_turn
    puts "=== Dealer's turn (#{dealer.name}) ==="
    dealer.reveal_hand
    dealer.turn(deck)
    puts "#{dealer.name} stays" unless Rules.busted?(dealer.hand_total)
    puts ""
  end

  def setup_dealer
    first_card = deck.draw_a_card
    first_card.reveal = false
    dealer.add_to_hand(first_card)
    dealer.add_to_hand(deck.draw_a_card)
  end

  def setup_player
    2.times do
      player.add_to_hand(deck.draw_a_card)
    end
  end

  def setup
    puts "=== Draw 2 cards for each player and dealer ==="
    setup_dealer
    setup_player
    show_hands(false)
  end

  def results
    puts "=== Round results ==="
    dealer.reveal_hand
    rules.results
    show_hands(true)
  end

  def show_hands(dealer_reveal)
    dealer_total = dealer_reveal ? dealer.hand_total : "?"
    puts "#{dealer.name}: #{dealer.show_hand} (total:#{dealer_total})"
    puts "#{player.name}: #{player.show_hand} (total:#{player.hand_total})"
    puts
  end

  def game_over?
    player.score == Round::MATCH_POINT ||
      dealer.score == Round::MATCH_POINT
  end

  def display_score
    puts "== Round Scores (First to #{MATCH_POINT})=="
    puts "#{player.name}'s rounds won: #{player.score}"
    puts "#{dealer.name}'s rounds won: #{dealer.score}"
    puts ""
  end
end

class TwentyOne
  PLAYER_NAME = "Peyton Manning"
  DEALER_NAME = "John Elway"
  attr_reader :dealer, :player, :round

  def self.clear_screen
    system('clear') || system('cls')
  end

  def initialize
    @player = Player.new(PLAYER_NAME)
    @dealer = Dealer.new(DEALER_NAME)
    @round = Round.new(@player, @dealer)
  end

  def start
    display_welcome_msg
    loop do
      round.play
      decision = exit
      break unless decision == 'y'
      round.reset
      player.reset_score
      dealer.reset_score
    end
    display_goodbye_msg
  end

  def exit
    choice = nil
    loop do
      puts "Do you want to play again? (type 'y' or 'n')?"
      choice = gets.chomp.downcase
      break if %w(y n).include? choice
      puts "Invalid input."
    end
    choice
  end

  def display_welcome_msg
    puts "Welcome! Let's play 21!"
    puts ""
  end

  def display_goodbye_msg
    puts ""
    puts "Thanks for playing! Goodbye!"
  end
end

t = TwentyOne.new
t.start
