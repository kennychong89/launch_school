=begin
Create the Class
Create an empty class named Cat.

Creating an Object
Create an instance of Cat and assign it to a variable named kitty.

What Are You?
Add an initialize method that prints I'm a cat! when a new Cat object is
initialized.

Hello, Sophie! (Part 1)
Add a parameter to #initialize that provides a name for the Cat object. 
Use an instance variable to print a greeting with the provided name.
(You can remove code that displays :I'm a cat!:).

Hello, Sophie! (Part 2)
Move greeting from #initialize method to instance method named #greet that
prints a greeting when invoked.

Reader
Add a getter method name #name and invoke it in place of @name in #greet

Writer
Add a setter method named #name. Then, rename kitty to 'Luna' and invoke #greet
again.

Accessor
Replace getter and setter methods using Ruby shorthand.

Walk the Cat
Create a module named Walkable that contains a method name #walk. This method
should print 'Let's go for a walk!' when invoked. Include Walkable in Cat
and invoke #walk in kitty.
=end

# Walk the Cat
module Walkable
  def walk
    puts "Let's go for a walk!"  
  end
end

# Create the Class
class Cat
  # Walk the Cat
  include Walkable
  
  # Reader
  attr_reader :name
  
  # Writer
  attr_writer :name
  
  # Accessor
  attr_accessor :name
  
  # What Are You?
  #def initialize
  #  puts "I'm a cat!"
  #end
  
  # Hello, Sophie!
  #def initialize(name)
  #  @name = name
  #  puts "Hello! My name is #{@name}!"
  #end
  
  # Hello, Sophie! (pt 2)
  def initialize(name)
    @name = name
  end
  
  #def greet
  #  puts "Hello! My name is #{@name}!"  
  #end
  
  # Reader
  def greet
    puts "Hello! My name is #{name}!"
  end
end

# Creating an Object
kitty = Cat.new('Sophie')
kitty.greet

# Reader
kitty.name = 'Luna'
kitty.greet

# Walk the Cat
kitty.walk