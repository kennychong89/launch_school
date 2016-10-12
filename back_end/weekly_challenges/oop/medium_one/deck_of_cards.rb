=begin
OO Exercises
Launch School
Kenny Chong 
10/12/2016 12:12 pm

https://launchschool.com/exercises/9bb05e87
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
  
  protected
  
  def convert_rank
    return 10 if rank == 'Ace'
    return 10 if %w(Jack Queen King).include? rank
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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
drawn != drawn2 # Almost always.