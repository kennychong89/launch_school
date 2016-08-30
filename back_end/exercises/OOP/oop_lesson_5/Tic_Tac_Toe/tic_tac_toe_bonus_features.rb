# frozen_string_literal: true
require 'yaml'
STRINGS = YAML.load_file('tic_tac_toe_bonus_features.yml')

module Message
  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing!"
  end

  def display_winning_message(winner_name)
    if winner_name
      puts "#{winner_name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_marker_choice
    puts "#{human.name} is a #{human.marker}. " \
         "#{computer.name} is a #{computer.marker}"
  end

  def display_board
    puts ""
    board.display_board
    puts ""
  end

  def display_rounds_won
    puts "Current Rounds Won:"
    puts "#{human.name}: #{score.retrieve(human.name)}"
    puts "#{computer.name}: #{score.retrieve(computer.name)}"
  end

  def display_rounds_to_win
    puts "Win #{TTTGame::ROUNDS_TO_WIN} rounds to win game."
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def unmarked_squares(line)
    @squares.values_at(*line).select(&:unmarked?).collect(&:marker)
  end

  def marked_squares(line)
    @squares.values_at(*line).select(&:marked?).collect(&:marker)
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def display_board
    puts create_display_board
  end

  private

  def create_display_board
    board = STRINGS['display_board'].clone

    @squares.each do |num, square|
      marker = square.marker
      initial_marker = Square::INITIAL_MARKER
      board.sub!("(#{num})", " #{marker} ") unless marker == initial_marker
    end
    board
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :name

  def initialize(marker, name, board)
    @marker = marker
    @name = name
    @board = board
  end

  def pick
  end
end

class Human < Player
  def pick
    puts "Choose a square between #{joiner(@board.unmarked_keys, ', ', 'and')}:"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if @board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    square
  end

  private

  def joiner(squares, seperator, end_seperator)
    joined_string = ''
    if squares.count == 1
      joined_string = squares[0]
    elsif squares.count == 2
      joined_string = squares.join(" #{end_seperator} ")
    elsif squares.count > 2
      joined_string = squares.join(seperator)
      joined_string.concat("#{end_seperator} " + joined_string.slice!(-1))
    end

    joined_string
  end
end

class Computer < Player
  def initialize(marker, name, board, opponent_marker)
    super(marker, name, board)
    @opponent_marker = opponent_marker
  end

  def pick
    winning_square = find_winning_square_location
    danger_square = find_danger_square_location

    if winning_square
      return winning_square
    elsif danger_square
      return danger_square
    elsif @board.unmarked_keys.include?(5)
      return 5
    end

    @board.unmarked_keys.sample
  end

  private

  def find_winning_square_location
    Board::WINNING_LINES.each do |line|
      if a_winning_line?(line) && line_has_empty_square?(line)
        return find_empty_square(line)
      end
    end
    nil
  end

  def find_empty_square(line)
    line.each do |square_index|
      return square_index if @board.unmarked_keys.include?(square_index)
    end
  end

  def find_danger_square_location
    Board::WINNING_LINES.each do |line|
      if a_danger_line?(line) && line_has_empty_square?(line)
        return find_empty_square(line)
      end
    end
    nil
  end

  def line_has_empty_square?(line)
    @board.unmarked_squares(line).count == 1
  end

  def a_winning_line?(line)
    @board.marked_squares(line).count(marker) == 2
  end

  def a_danger_line?(line)
    @board.marked_squares(line).count(@opponent_marker) == 2
  end
end

class Score
  def initialize(names)
    @score_card = {}
    names.each do |name|
      reset(name)
    end
  end

  def reset(name)
    @score_card[name] = 0
  end

  def retrieve(name)
    @score_card[name] if name
  end

  def award(name, points)
    @score_card[name] += points if name
  end
end

class TTTGame
  include Message
  ROUNDS_TO_WIN = 5
  HUMAN_NAME = "Human"
  COMPUTER_NAME = "Bob Ross"
  X_MARKER = "X"
  O_MARKER = "O"
  FIRST_TO_MOVE = X_MARKER
  attr_reader :board, :human, :computer, :score

  def initialize
    human_marker = human_pick_marker
    comp_marker = computer_pick_marker(human_marker)
    @board = Board.new
    @human = Human.new(human_marker, HUMAN_NAME, @board)
    @computer = Computer.new(comp_marker, COMPUTER_NAME, @board, @human.marker)
    @current_marker = FIRST_TO_MOVE
    @score = Score.new([HUMAN_NAME, COMPUTER_NAME])
  end

  def start_game
    display_welcome_message
    clear
    loop do
      display_rounds_to_win
      run_game_loop
      break unless play_again?
      display_play_again_message
      reset
      reset_score
    end
    display_goodbye_message
  end

  private

  def human_pick_marker
    human_pick = O_MARKER
    loop do
      puts "Please select your marker (X or O)"
      human_pick = gets.chomp
      break if [X_MARKER, O_MARKER].include? human_pick
      puts "Invalid selection. Choose again."
    end
    human_pick
  end

  def computer_pick_marker(human_marker)
    human_marker == O_MARKER ? X_MARKER : O_MARKER
  end

  def run_game_loop
    loop do
      clear_screen_and_display_board
      play_round
      award_round(winner?)
      display_marker_choice
      display_board
      display_winning_message(winner?)
      display_rounds_won
      break unless !won_game?
      prompt_start_next_round
      reset
    end
  end

  def prompt_start_next_round
    puts "Press enter to start next round."
    gets.chomp
  end

  def play_round
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      display_marker_choice
      display_board
    end
  end

  def won_game?
    score.retrieve(human.name) == ROUNDS_TO_WIN ||
      score.retrieve(computer.name) == ROUNDS_TO_WIN
  end

  def winner?
    if board.winning_marker == human.marker
      human.name
    elsif board.winning_marker == computer.marker
      computer.name
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def current_player_moves
    if human_turn?
      board[human.pick] = human.marker
      @current_marker = computer.marker
    else
      board[computer.pick] = computer.marker
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def award_round(winner_name)
    if winner_name == human.name
      score.award(human.name, 1)
    elsif winner_name == computer.name
      score.award(computer.name, 1)
    end
  end

  def reset_score
    score.reset(human.name)
    score.reset(computer.name)
  end

  def reset
    board.reset
    clear
    @current_marker = FIRST_TO_MOVE
  end

  def clear
    system('clear') || system('cls')
  end

  def clear_screen_and_display_board
    clear
    display_marker_choice
    display_board
  end
end

game = TTTGame.new
game.start_game
