VALID_CHOICES = %w(rock paper scissors) # array with string element

def display_results(choice, computer_choice)
  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")
  if win?(choice, computer_choice)
    prompt("You won!")
  elsif win?(computer_choice, choice)
    prompt("Computer won!")
  else
    prompt("It is a tie!")
  end
end

def win?(first, second)
  (first == 'rock' && second == 'scissors') || 
  (first == 'paper' && second == 'rock') ||
  (first == 'scissors' && second == 'paper')
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

loop do
  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp()

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That is not a valid choice.")
    end
  end
  computer_choice = VALID_CHOICES.sample()
  
  display_results(choice, computer_choice)

  prompt("Do you want to play again?")
  answer = Kernel.gets().chomp()

  break unless answer.downcase().start_with?('y')
end

prompt("Thank you for playing!")
