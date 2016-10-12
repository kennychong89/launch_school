=begin
OO Exercises
Launch School
Kenny Chong 
10/12/2016 12:34 pm

https://launchschool.com/exercises/a1938086
=end

class Card
  include Comparable
  attr_reader :rank, :suit
  
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  
  def to_s
    "#{@rank} of #{@suit}"  
  end
  
  def <=>(other_card)
    convert_rank <=> other_card.convert_rank  
  end

  def convert_rank
    return 12 if rank == 'Ace'
    return 11 if %w(Jack Queen King).include? rank
    return rank
  end
end

class Deck
  RANKS = (2..10).to_a + %w(Jack Queen King Ace).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  
  def initialize
    @deck = create_deck.shuffle
  end
  
  def draw
    @deck = create_deck.shuffle if @deck.size == 0 
    @deck.shift     
  end
  
  private
  
  def create_deck
    RANKS.product(SUITS).map do |rank, suit|
      Card.new(rank, suit)    
    end
  end
end

class PokerHand
  def initialize(deck)
    @hand = Array.new(5) { deck.draw }
    @card_count = initialize_hand_count
    #puts @card_count
  end

  def print
    puts @hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    # Hand is a 10,Jack,Queen,King,Ace and suits are same
  end

  def straight_flush?
    # Hand is straight and suits are same
  end

  def four_of_a_kind?
    # Hand has 4 cards that are of same rank
  end

  def full_house?
    # three_of_a_kind + a pair
    three_of_a_kind? + pair?
  end

  def flush?
    # Hand has 5 cards that are of same suit
  end

  def straight?
    # Hand has cards that are +1 rank above the previous
    # card and card ranks are consecutive.
    keys = @card_count.values.flatten
    ranks = keys.map { |card| card.convert_rank }
    (keys.min.rank..(keys.min.rank)+4).to_a == ranks.sort
  end

  def three_of_a_kind?
    # Hand has at least 3 cards with same rank
    @card_count.each_value do |cards| 
      return true if cards.size == 3
    end
    false
  end

  def two_pair?
    count = 0
    @card_count.each_value do |cards|
      count += 1 if cards.size == 2    
    end
    count == 2
  end

  def pair?
    # Hand has at least two cards with same rank
    @card_count.each_value do |cards| 
      return true if cards.size == 2
    end
    false
  end
  
  private
  
  def initialize_hand_count
    hand = {}
    @hand.each do |card|
      if hand.has_key? card.rank
        hand[card.rank].push(card)
      else
        hand[card.rank] = [card]
      end
    end
    hand
  end
end

#hand = PokerHand.new(Deck.new)
#hand.print
#puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(4, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(2, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'
