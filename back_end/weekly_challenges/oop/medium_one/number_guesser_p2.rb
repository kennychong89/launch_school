=begin
OO Exercises
Launch School
Kenny Chong 
10/12/2016 11:42 pm

https://launchschool.com/exercises/e50996f7
=end

class PingGame
  attr_reader :low, :high
  
  def initialize(low, high)
    @low = low
    @high = high
    @number_of_guesses = Math.log2(high - low + 1).to_i + 1
    @winning_number = rand(low..high)
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
    print "Enter a number between #{low} and #{high}: "   
    loop do
      guess = gets.chomp.to_i
      break unless guess > high || guess < low
      print "Invalid guess. Enter a number between #{low} and #{high}: "
    end
    guess
  end
end

game = PingGame.new(501, 1500)
game.play