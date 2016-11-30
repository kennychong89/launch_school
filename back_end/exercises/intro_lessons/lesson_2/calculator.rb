# ask the user for two numbers
# ask the user for an operation to perform
# perform the operation on two numbers
# output the result

#answer = Kernal.gets()
#puts Kernel.answer()

def prompt(message)
    Kernel.puts("=> #{message}")
end

def valid_number?(num)
    num.to_i != 0 # doesn't make sense if num is actually the number 0, but it is okay for now.
end

def operation_to_message(op)
    case op
    when '1'
      'Adding'
    when '2'
      'Subtracting'
    when '3'
      'Multiplying'
    when '4'
      'Dividing'
    end
end

prompt("Welcome to Calculator! Enter your name:")
name = ''

loop do
  name = Kernel.gets.chomp

  if name.empty?
    prompt("Make sure to use a valid name.")
  else
    break
  end
end

prompt("Hi #{name}!")
loop do #main loop
  number1 = ''
  loop do # creates a new block
    prompt("What's the first number?")
    number1 = Kernel.gets.chomp

    if valid_number?(number1)
      break
    else
      prompt("Hmm... that doesn't look like a valid number")
    end
  end

  number2 = ''
  loop do 
    prompt("What's the second number?")
    number2 = Kernel.gets.chomp

    if valid_number?(number2)
      break
    else
      prompt("Hmm... that doesn't look like a valid number")
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG
  
  prompt(operator_prompt)

  operator = ''
  loop do
    operator = Kernel.gets.chomp
  
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt("Must 1, 2, 3 or 4")
    end
  end

  prompt("#{operation_to_message(operator)} the two numbers...")
  
  result = case operator
           when '1'
             number1.to_i + number2.to_i
           when '2'
             number1.to_i - number2.to_i
           when '3'
             number1.to_i * number2.to_i
           when '4'
             number1.to_f / number2.to_f
  end

  prompt("The result is: #{result}")
  prompt("Do you want to perform another calculation? (Y to calculate again)")
  
  answer = Kernel.gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt("Smell ya later")

# Questions to consider
# 1. Is there a better way to validate that the user has input a number? 
# => We can regex to check if it is a number
# => If the string is in ASCII format, we can convert each character to its ASCII representation. Usually ASCII numeric values (0-9) have a specific range.
# => Integer(num). if num is not a number it will throw an exception. Use can create a rescue block to catch error.

# 3. Our operation_to_message method is a little dangerou, because we're relying on the 'case' statement being the last expression in the method. What if we
# need to add some code after the case statement within the method? What changes would be needed to keep the method working with the rest of the program?
# => We can save the case result in a variable and return the variable at the end of the method:
# def operation_to_message(op)
#    result = case op
#    when '1'
#      'Adding'
#    when '2'
#      'Subtracting'
#    when '3'
#      'Multiplying'
#    when '4'
#      'Dividing'
#    end
#    ...
#    
#   result
#end
#
#
# We're using Kernel.puts() and Kernel.gets(). But the Kernel. is extraneous as well as the parentheses. 
# Therefore, we can just call those methods by gets and puts. We already know that in Ruby we can omit the parentheses, but how come we can also omit the Kernel.?
# Answer: Kernal module is part of the Object class, and since Object is automatically avaliable in every Ruby program, we don't need to use the Kernel part for
# every method that is in the Kernal module.

