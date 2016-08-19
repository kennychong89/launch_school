# frozen_string_literal: true
class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze
  def initialize(value)
    @value = value
  end

  def >(other_move)
    (rock? && rock_wins?(other_move)) ||
      (paper? && paper_wins?(other_move)) ||
      (scissors? && scissors_wins?(other_move)) ||
      (spock? && spock_wins?(other_move)) ||
      (lizard? && lizard_wins?(other_move))
  end

  def <(other_move)
    (rock? && rock_loses?(other_move)) ||
      (paper? && paper_loses?(other_move)) ||
      (scissors? && scissors_loses?(other_move)) ||
      (spock? && spock_loses?(other_move)) ||
      (lizard? && lizard_loses?(other_move))
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

  def to_s
    @value
  end

  private

  def spock_wins?(other_move)
    other_move.scissors? || other_move.rock?
  end

  def lizard_wins?(other_move)
    other_move.spock? || other_move.paper?
  end

  def scissors_wins?(other_move)
    other_move.paper? || other_move.lizard?
  end

  def paper_wins?(other_move)
    other_move.rock? || other_move.spock?
  end

  def rock_wins?(other_move)
    other_move.lizard? || other_move.scissors?
  end

  def rock_loses?(other_move)
    other_move.paper? || other_move.spock?
  end

  def paper_loses?(other_move)
    other_move.lizard? || other_move.scissors?
  end

  def scissors_loses?(other_move)
    other_move.rock? || other_move.spock?
  end

  def spock_loses?(other_move)
    other_move.lizard? || other_move.paper?
  end

  def lizard_loses?(other_move)
    other_move.rock? || other_move.scissors?
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
    @score = Score.new
    @history = History.new
  end

  def award_round
    @score.add(1)
  end

  def current_rounds_won
    @score.points
  end

  def reset_rounds_played
    @score.points = 0
  end

  def moves_played
    @history.moves
  end

  protected

  def record_move
    @history.add(move)
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose (r)ock, (p)aper, (s)cissors, (l)izard, sp(o)ck:"
      choice = type_of(gets.chomp)
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
    record_move
  end

  private

  def type_of(choice)
    if choice.casecmp('r') == 0
      return 'rock'
    elsif choice.casecmp('p') == 0
      return 'paper'
    elsif choice.casecmp('s') == 0
      return 'scissors'
    elsif choice.casecmp('l') == 0
      return 'lizard'
    elsif choice.casecmp('o') == 0
      return 'spock'
    end
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
    @opponent_move = nil
  end

  def choose
    self.move = if move.nil?
                  Move.new(['scissors', 'spock'].sample)
                elsif move > @opponent_move
                  Move.new(@opponent_move.to_s)
                elsif move < @opponent_move
                  Move.new(counter_pick(@opponent_move))
                else
                  Move.new(Move::VALUES.sample)
                end
    record_move
  end

  def save(opponent_move)
    @opponent_move = opponent_move
  end

  private

  def counter_pick(move)
    if move.rock?
      return ['paper', 'spock'].sample
    elsif move.paper?
      return ['scissors', 'lizard'].sample
    elsif move.scissors?
      return ['rock', 'spock'].sample
    elsif move.lizard?
      return ['rock', 'scissors'].sample
    elsif move.spock?
      return ['paper', 'lizard'].sample
    end
  end
end

class Score
  attr_accessor :points

  def initialize
    @points = 0
  end

  def add(points)
    self.points += points
  end

  def to_s
    "#{points} points"
  end
end

class History
  attr_accessor :moves

  def initialize
    @moves = []
  end

  def add(move)
    @moves.push(move)
  end
end

class RPSGame
  attr_accessor :human, :computer
  MAX_ROUNDS_PLAYED = 10
  def initialize
    @human = Human.new
    @computer = Computer.new
    @table_size = 0
    @table_data = []
    @table_data.push(["Rounds", human.name, computer.name, "Winner"])
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Good bye!"
  end

  def display_score
    puts "#{human.name} has won #{human.current_rounds_won} rounds."
    puts "#{computer.name} has won #{computer.current_rounds_won} rounds."
  end

  def display_moves_played
    max_column_lengths = find_max_column_lengths

    @table_data.each do |data|
      format_rule = max_column_lengths.map { |len| "%#{len}s" }.join(" " * 5)
      puts format_rule % data
    end
  end

  def add_to_table_data
    human_moves = human.moves_played
    computer_moves = computer.moves_played
    name = winner_name

    if name.nil?
      name = 'Tied'
    end

    @table_data.push([(@table_size + 1).to_s,
                      human_moves[@table_size].to_s,
                      computer_moves[@table_size].to_s,
                      name])
    @table_size += 1
  end

  def clear_table
    @table_data = []
    @table_data.push(["Rounds", human.name, computer.name, "Winner"])
    @table_size = 0
  end

  def find_max_column_lengths
    max_col_lengths = [0, 0, 0, 0]

    @table_data.each do |row|
      row.each_with_index do |column, i|
        max_col_lengths[i] = column.size if column.size > max_col_lengths[i]
      end
    end

    max_col_lengths
  end

  def winner_name
    if human.move > computer.move
      human.name
    elsif computer.move > human.move
      computer.name
    end
  end

  def display_moves_chosen
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if winner_name == human.name
      puts "#{human.name} won!"
    elsif winner_name == computer.name
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def give_winner_point
    if winner_name == human.name
      human.award_round
    elsif winner_name == computer.name
      computer.award_round
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
    end

    return true if answer == 'y'
  end

  def play
    loop do
      players_choose
      computer.save(human.move)
      give_winner_point
      add_to_table_data
      display
      break unless human.current_rounds_won != MAX_ROUNDS_PLAYED \
                && computer.current_rounds_won != MAX_ROUNDS_PLAYED
    end
  end

  def display
    display_moves_chosen
    display_winner
    display_score
    display_moves_played
  end

  def players_choose
    human.choose
    computer.choose
  end

  def run_game
    display_welcome_message
    loop do
      play
      break unless play_again?
      human.reset_rounds_played
      computer.reset_rounds_played
      clear_table
    end
    display_goodbye_message
  end
end

RPSGame.new.run_game
