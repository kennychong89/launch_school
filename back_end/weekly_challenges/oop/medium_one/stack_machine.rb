=begin
OO Exercises
Launch School
Kenny Chong 
10/08/2016 3:31 PM

https://launchschool.com/exercises/1fcae291
=end

class Minilang
  BINARY_OPERATIONS = ["ADD", "SUB", "DIV", "MULT", "MOD"]
  UNARY_OPERATIONS = ["PRINT", "PUSH", "POP"]
  
  def initialize(program)
    @program = program.split(' ')
    @register = 0
    @stack = Array.new
  end
  
  def eval
    @program.each do |token|
        begin
          raise "Invalid tokens: #{token}" unless valid?(token)  
          self.register = token.to_i if number?(token)
          push(register) if token.downcase == "push"
          self.register = pop if token.downcase == "pop"
          print_register if token.downcase == "print"
          self.register = perform_operation(token, register, pop) if binary?(token)
        rescue Exception => e
          puts e.message
        end
    end    
  end
  
  private
  
  attr_accessor :register
  
  def push(num)
    @stack.push(num)
  end
  
  def pop
    raise "Empty stack!" if @stack.empty?
    @stack.pop
  end
  
  def print_register
    puts @register     
  end
  
  def valid?(token)
    number?(token) || binary?(token) || unary?(token)
  end

  def binary?(token)
    BINARY_OPERATIONS.include?(token)   
  end
  
  def unary?(token)
    UNARY_OPERATIONS.include?(token)  
  end
  
  def number?(token)
    token =~ /^-?\d+$/
  end
  
  def perform_operation(operation, a, b)
    result = case operation
             when "ADD"
               a + b
             when "SUB"
               a - b
             when "DIV"
               a / b
             when "MULT"
               a * b
             when "MOD"
               a % b
             end
    result
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval

Minilang.new('-3 PUSH 5 XSUB PRINT').eval

Minilang.new('-3 PUSH 5 SUB PRINT').eval

Minilang.new('6 PUSH').eval