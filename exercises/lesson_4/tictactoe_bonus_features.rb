# Tic Tac Toe with bonus features
# Kenny Chong
# 05/04/2016
require 'pry'
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals
WINNING_MATCH_POINT = 5
PLAYER_NAME = "Player"
COMPUTER_NAME = "Computer"
CHOOSE = "Choose"
WHO_GOES_FIRST = CHOOSE

def prompt(msg)
  puts "=> #{msg}"
end

def clear_screen
  system('clear')
end

# rubocop:disable Metrics/MethodLength
def display_board(brd)
  puts "You are a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/MethodLength Abc/Size

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joiner(squares, seperator, end_seperator)
  joined_string = ''
 
  if squares.count == 1
    joined_string = squares[0]
  elsif squares.count == 2
    joined_string = squares.join(" #{end_seperator} ") # ex: 1 and 2
  elsif squares.count > 2
    joined_string = squares.join(seperator)
    joined_string.concat("#{end_seperator} " + joined_string.slice!(-1)) # ex: 1,2, and 3
  end

  joined_string
end

def player_places_piece!(brd)
  square = ''
  loop do
    selection_string = joiner(empty_squares(brd), ', ', 'and')
    prompt "Choose a square (#{selection_string}):"
    square = gets.chomp.to_i

    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's is not a valid choice."
  end

  brd[square] = PLAYER_MARKER

  square
end

### COMPUTER OPPONENT RELATED METHODS ###
def semi_smart_computer_places_piece!(brd)
  winning_square = find_winning_square_location(brd)
  danger_square = find_danger_square_location(brd)

  if winning_square
    brd[winning_square] = COMPUTER_MARKER
  elsif danger_square
    brd[danger_square] = COMPUTER_MARKER
  elsif square_is_empty(brd, 5)
    brd[5] = COMPUTER_MARKER
  else
    computer_places_piece_at_random!(brd)
  end 
end

def computer_places_piece_at_random!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def offensive_computer_places_piece!(brd)
  winning_square = find_winning_square_location(brd)

  if winning_square
    brd[winning_square] = COMPUTER_MARKER
  else
    computer_places_piece_at_random!(brd)
  end
end

def defensive_computer_places_piece!(brd)
  # a danger square is a square that the player may mark his piece and win the game.
  danger_square = find_danger_square_location(brd)

  if danger_square
    brd[danger_square] = COMPUTER_MARKER
  else
    computer_places_piece_at_random!(brd)
  end 
end

def find_winning_square_location(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2 && line_has_empty_space(brd, line)
      return line_get_empty_space(brd, line)
    end
  end
  nil
end

def find_danger_square_location(brd)
  danger_line = nil
  #selected_lines = filter_lines(player_marked_square_index)
  
  WINNING_LINES.each do |line|
    danger_line = line if is_a_danger_line(brd, line)
    break unless danger_line == nil  
  end
    
  line_get_empty_space(brd, danger_line) if danger_line != nil
end

def filter_lines(selected_square_index)
  lines = WINNING_LINES.select do |line|
    line.include?(selected_square_index)
  end
end

def is_a_danger_line(brd, line)
  count = 0
  
  line.each do |square_index|
    count = count + 1 if brd[square_index] == PLAYER_MARKER 
  end

  count == 2 && line_has_empty_space(brd, line)
end

def line_has_empty_space(brd, line)
  line.each do |square_index|
    return true if brd[square_index] == INITIAL_MARKER   
  end

  false
end

def line_get_empty_space(brd, line)
  line.each do |square_index|
    return square_index if brd[square_index] == INITIAL_MARKER   
  end
end

def square_is_empty(brd, square_index)
  brd[square_index] == INITIAL_MARKER
end
#########################################

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return PLAYER_NAME
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return COMPUTER_NAME
    end
  end
  nil
end

def update_score(score_card, winner_name)
  score_card[winner_name] += 1 if winner_name != nil
end

def display_score(score_card)
  prompt "Current Score:"
  score_card.each do |name, score|
    prompt "#{name}: #{score}"
  end
end

def display_game_winner(score_card)
  score_card.each do |name, score| 
    if score == MATCH_SCORE
      prompt "The winner is #{name}! Congrats!"
    end
  end
end

def initialize_score_card
  { PLAYER_NAME => 0, COMPUTER_NAME => 0 }
end

def play_again?
  prompt "Play again? (y or n)"
  answer = gets.chomp

  answer
end

def display_current_round_results(board)
  if someone_won?(board)
    prompt "#{detect_winner(board)} won the round!"
  else
    prompt "It's a tie!"
  end
end

def reached_max_points?(player_name, score_card, winning_match_point)
  score_card[player_name] == winning_match_point
end

def play_round(board)
  whose_turn = WHO_GOES_FIRST
  if whose_turn == CHOOSE then whose_turn = ask_player_to_choose end

  loop do
    clear_screen
    display_board(board)
    place_piece!(board, whose_turn)
    whose_turn = alternate(whose_turn)
    break if someone_won?(board) || board_full?(board)
  end
end

def place_piece!(brd, current_player)
  if current_player == COMPUTER_NAME
    semi_smart_computer_places_piece!(brd)
  else
    player_places_piece!(brd)
  end
end

def alternate(current_player)
  if current_player == COMPUTER_NAME
    PLAYER_NAME
  else
    COMPUTER_NAME
  end
end

def ask_player_to_choose
  choice = ''
  loop do
    prompt "Type 1 for player to go first. Type 2 for computer to go first."
    choice = gets.chomp

    break unless choice != "1" && choice != "2"

    prompt "Invalid choice. Please press 1 for player to go or 2 for computer to go."
  end

  if choice == "2" 
    COMPUTER_NAME 
  else 
    PLAYER_NAME
  end
end

def run_game_loop
  score_card = initialize_score_card
  winning_match_point = 5
  loop do
    board = initialize_board
    play_round(board)
    winner_name = detect_winner(board)
    update_score(score_card, winner_name)
    display_board(board)
    display_current_round_results(board)
    display_score(score_card)  
    
    break if reached_max_points?(winner_name, score_card, winning_match_point) ||
             reached_max_points?(winner_name, score_card, winning_match_point)

    prompt "Press enter to start next round."
    gets.chomp
  end
end

def start_game
  loop do
    clear_screen
    run_game_loop
    continue = play_again?
    break unless continue.downcase.start_with?('y')
  end

  prompt "Thanks for playing Tic Tac Toe! Later!"
end

start_game



