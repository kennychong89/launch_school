=begin
OO Exercises
Launch School
Kenny Chong 
10/12/2016 10:40 pm

https://launchschool.com/exercises/e4b17f84
=end

class PingGame
  RANGE = 1..100
  MAX_GUESSES = 7
  
  def initialize
    @number_of_guesses = MAX_GUESSES
    @winning_number = rand(RANGE)
  end
  
  def play
    loop do
      display_guesses_remaining
      guess = prompt_user_guess
      result = check_guess(guess)
      display_guess_result(result)
      break if result == :win
      @number_of_guesses -= 1
      if @number_of_guesses == 0
        puts "You are out of guesses. You lose."
        break
      end
    end
  end
  
  private
  
  def check_guess(guess)
    return :high if  guess > @winning_number
    return :low if guess < @winning_number
    return :win if guess == @winning_number
  end
  
  def display_guess_result(result)
    puts "Your guess is too high." if result == :high
    puts "Your guess is too low." if result == :low
    puts "You win!" if result == :win
  end
  
  def display_guesses_remaining
    if @number_of_guesses == 1
      puts "You have #{@number_of_guesses} guess remaining."
    else
      puts "You have #{@number_of_guesses} guesses remaining."
    end
  end
  
  def prompt_user_guess
    guess = nil
    loop do
      print "Enter a number between 1 and 100: "    
      guess = gets.chomp.to_i
      break unless guess > 100 || guess < 1
      print "Invalid guess. Enter a number between 1 and 100: "
    end
    guess
  end
end

PingGame.new.play