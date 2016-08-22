# Launch School 
# Lesson 4: OO Exercises Medium 1
# Kenny Chong
# 08/21/2016 9:18 PM

# Ben asked Alyssa to code review the following code
class BankAccount
  attr_reader :balance
  
  def initialize(starting_balance)
    @balance = starting_balance  
  end
  
  def positive_balance?
    balance >= 0  
  end
end

# Alyssa glanced over the code quickly and said - "It looks fine, except that
# you forgot to put the @ before balance when you refer to the balance instance
# variable in the body of the positive_balance? method."

# "Not so fast", Ben replied. "What I'm doing here is valid - I am not missing
# an @!"

# Who is right, Ben or Alyssa, and why?
# Answer:
# Neither is wrong - Ben can use balance inside the positive_balance? method
# because the class has a getter method from the attr_reader. As a result, 
# balance is a getter method returning a value and that value is being compared
# to 0. Adding @ will also work because it is directly fetching the value from
# the instance variable instead from the getter. 

# 2. Alyssa created the following code to keep track of items for a shopping
# cart application she's writing:
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# Alan looked at the code and spotted a mistake. "This will fail when 
# update_quantity is called," he says.

# Answer: should be self.quantity since without the self, quantity is 
# a local variable. Change attr_reader to attr_accessor as well.

# 3. In the last question Alyssa show Alan this code which keeps track of
# items for a shopping cart application:
class InvoiceEntry
  attr_reader :quantity, :product_name
  
  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end
  
  def update_quantity(updated_count)
    quantity = update_count if updated_count >= 0  
  end
end

# Alan noticed that this will fail when update_quantity is called. Since 
# quantity is an instance variable, it must be accessed with the @quantity
# notation when setting it. One way to fix this is to change attr_reader to
# attr_accessor and change quantity to self.quantity.

# Is there anything wrong with fixing it this way?
# Answer: No, this is a valid way to fix it. However, it also allow others
# to modify quantity using it setter method. If Alan needs prevent others 
# modifying @quantity with a setter, then it better to use @quantity.

# 4. Create a class called Greeting with a single method called greet that
# takes a string argument and prints the argument to the terminal.

# Now create two other classes that are derived from Greeting: one called
# Hello and one called Goodbye. The Hello class should have a hi method
# that takes no arguments and prints "Hello". The Goodbye class should have
# a bye method to say "Goodbye". Make use of the Greeting class greet method
# when implementing the Hello and Goodbye classes - do not use any puts in the
# Hello or Goodbye classes.

# Answer:
class Greeting
  def greet(msg)
   puts msg
  end
end

class Hello < Greeting
  def hi
    greet("Hello")  
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# 5. You are given the following class that has been implemented:
class KrispyKreme
   def initialize(filling_type, glazing)
     @filling_type = filling_type
     @glazing = glazing
   end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1 # Plain
puts donut2 # Vanilla
puts donut3 # Plain with sugar
puts donut4 # Plain with chocolate sprinkles
puts donut5 # Custard with icing

# Write addition code for KrispyKreme such that the puts statements 
# will work as specified above.
# Answer:
def to_s
  # My Solution:
  if @filling_type.nil? and !@glazing.nil?
    return "Plain with #{@glazing}"
  elsif !@filling_type.nil? and !@glazing.nil?
    return "#{@filling_type} with #{@glazing}"
  elsif @filling_type.nil? and @glazing.nil?
    return "Plain"    
  end
  
  @filling_type
  
  # Alternate Solution (Simpler):
  filling_string = @filling_type ? @filling_type : "Plain"
  glazing_string = @glazing ? " with #{@glazing}" : ''
  filling_string + glazing_string
end

# 6.
# If we have these two methods:
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# and 

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# The second method does not use any instance variables, so I assume 
# I will need to call the create_template first in order for the show_template
# to display the right template.

# Alternate Answer: No difference, better convention not to use self.

# 7. How could you change the method name below so that the method name
# is more clear and less repetitive.
class Light
  attr_accessor :brightness, :color
  
  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end
  
  def self.light_information
    "I want to turn on the light with a brightness level of super high and a ..."  
  end
end

# Answer:
def light_intensity
   "Current brightness: #{brightness}, Current color: #{color}" 
end

# Alternate Answer:
def self.information
end