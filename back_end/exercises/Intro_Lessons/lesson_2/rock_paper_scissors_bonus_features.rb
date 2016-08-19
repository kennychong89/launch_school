# Rock, Papers, Scissors + Bonus Features
# Kenny Chong
# 04/27/2016
require 'yaml'
YAML_FILE = YAML.load_file('rock_paper_scissors_bonus_features.yml')
VALID_HEROES = { "r" => "rock", "p" => "paper", "s" => "scissors", "o" => "spock", "l" => "lizard" }
MAX_POINTS = 5
SLEEP_DURATION = 0.3

def rock_wins_against?(challenger)
  challenger == 'lizard' || challenger == 'scissors'
end

def paper_wins_against?(challenger)
  challenger == 'spock' || challenger == 'rock'
end

def scissors_wins_against?(challenger)
  challenger == 'lizard' || challenger == 'paper'
end

def spock_wins_against?(challenger)
  challenger == 'rock' || challenger == 'scissors'
end

def lizard_wins_against?(challenger)
  challenger == 'spock' || challenger == 'paper'
end

def ask_for_hero
  hero = ''
  loop do
    prompt("Choose your hero wisely: #{YAML_FILE['valid_heros_selection']}")
    hero = gets.chomp

    break if user_typed_shortcut?(hero)
    prompt(YAML_FILE['not_valid_selection'])
  end

  VALID_HEROES[hero]
end

def pick_random_hero
  VALID_HEROES.values.sample
end

def user_typed_shortcut?(shortcut)
  VALID_HEROES.key?(shortcut.downcase)
end

def ask_user_for_name
  name = ''
  loop do
    prompt(YAML_FILE['enter_name'])
    name = gets.chomp
    break unless name.empty?
    prompt(YAML_FILE['need_name_again'])
  end

  name
end

def ask_user_to_continue?(user_name)
  answer = ''
  loop do
    prompt("#{user_name}, #{YAML_FILE['play_again']}")
    answer = gets.chomp
    break if answer.downcase.start_with?('y', 'n')
    prompt(YAML_FILE['y_or_n_to_exit'])
  end

  answer
end

def determine_winner_and_loser(player_1_name, player_1_hero, player_2_name, player_2_hero)
  results = { winner_name: '', winner_hero: '', loser_name: '', loser_hero: '' }

  if win?(player_1_hero, player_2_hero)
    results = mark_winner_and_loser(player_1_name, player_1_hero, player_2_name, player_2_hero)
  elsif win?(player_2_hero, player_1_hero)
    results = mark_winner_and_loser(player_2_name, player_2_hero, player_1_name, player_1_hero)
  end

  results
end

def mark_winner_and_loser(winner_name, winner_hero, loser_name, loser_hero)
  results = {}
  results[:winner_name] = winner_name
  results[:winner_hero] = winner_hero
  results[:loser_name] = loser_name
  results[:loser_hero] = loser_hero
  results
end

def display_players_selections(player_1_name, player_1_hero, player_2_name, player_2_hero)
  prompt("#{player_1_name} chose: #{player_1_hero}.")
  prompt("#{player_2_name} chose: #{player_2_hero}.")
end

def display_congrats_to_winner(winner_name, current_round)
  if winner_name != ''
    prompt("Congrats, #{winner_name} has won round #{current_round}.")
  else
    prompt("#{YAML_FILE['tied']} #{current_round}")
  end
end

def display_match_results(winner, loser)
  match_between = winner + "_" + loser
  if YAML_FILE['match_results'].key?(match_between)
    prompt(YAML_FILE['match_results'][match_between])
  end
end

def win?(player_1_hero, player_2_hero)
  is_winner = case player_1_hero
              when 'rock' then rock_wins_against?(player_2_hero)
              when 'paper'then paper_wins_against?(player_2_hero)
              when 'scissors' then scissors_wins_against?(player_2_hero)
              when 'spock' then spock_wins_against?(player_2_hero)
              when 'lizard' then lizard_wins_against?(player_2_hero)
              end
  is_winner
end

def update_score(winner_name, score_card)
  score_card[winner_name] += 1 if score_card.key?(winner_name)
end

def display_users_score(score_card)
  score_card.each do |name, score|
    prompt(name + ": #{score}")
  end
end

def display_current_score(score_card)
  prompt(YAML_FILE['current_score'])
  display_users_score(score_card)
end

def display_final_score(score_card)
  prompt(YAML_FILE['final_score'])
  display_users_score(score_card)
end

def reached_max_points?(player_name, score_card)
  score_card[player_name] == MAX_POINTS
end

def invoke_countdown
  prompt("Ready!?")
  VALID_HEROES.values.each do |heros|
    prompt(heros + "!")
    sleep(SLEEP_DURATION)
  end
  prompt("Shoot!\n")
end

def prompt(message)
  puts("=> #{message}")
end

def pick_heros
  player1 = ask_for_hero
  player2 = pick_random_hero

  [player1, player2]
end

def run_round(current_round, p1_name, p1_hero, p2_name, p2_hero)
  invoke_countdown # optional simulation
  prompt("RESULTS AT ROUND #{current_round}:")
  display_players_selections(p1_name, p1_hero, p2_name, p2_hero)
  results = determine_winner_and_loser(p1_name, p1_hero, p2_name, p2_hero)
  display_match_results(results[:winner_hero], results[:loser_hero])
  display_congrats_to_winner(results[:winner_name], current_round)
  results[:winner_name]
end

def run_game_loop(user_name, computer_name)
  score_card = { user_name => 0, computer_name => 0 }
  current_round = 1
  loop do
    user_hero, computer_hero = pick_heros
    winner_name = run_round(current_round, user_name, user_hero, computer_name, computer_hero)
    update_score(winner_name, score_card)
    display_current_score(score_card)
    current_round += 1
    break if reached_max_points?(user_name, score_card) ||
             reached_max_points?(computer_name, score_card)
  end

  display_final_score(score_card)
end

def start_game
  prompt(YAML_FILE['welcome'])
  prompt("The first to get #{MAX_POINTS} wins.")
  user_name = ask_user_for_name
  computer_name = YAML_FILE['computer_name']
  loop do
    run_game_loop(user_name, computer_name)
    continue = ask_user_to_continue?(user_name)
    break unless continue == 'y'
  end
  prompt(YAML_FILE['goodbye'])
end

start_game
