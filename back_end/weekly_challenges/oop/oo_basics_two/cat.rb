=begin
Generic Greeting (Pt 1)
Modify the following code so that 
Hello! I'm a cat! is printed when Cat.generic_greeting is invoked.

class Cat
end

Cat.generic_greeting

Expected output:

Hello! I'm a cat!

Hello, Chloe!
Add an instance method named #rename that renames kitty when invoked.
class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

kitty = Cat.new('Sophie')
kitty.name
kitty.rename('Chloe')
kitty.name

Identify Yourself (Part 1)
Add a method named #identify that returns its calling object.

Generic Greeting (Part 2)
Add two methods ::generic_greeting and #personal greeting.
The first method is a class method and prints a greeting generic
to the class. The second method should be an instane method and print 
a greeting that's custom to the object.

Counting Cats
Create a class method named Cat that tracks number of times a new Cat
is instantiated. The total number of Cat instances should be printed when
#total is invoked.

Colorful Cat
Create a class named Cat that prints a greeting when #greet is invoked.
The greeting should include the name and color of the cat. Use a 
constant to define the color.

Identify Yourself (Part 2)
Modify the following code so that "I'm Sophie!" is printed when
puts kitty is invoked.
=end

class Cat
   attr_accessor :name
   @@number_of_cats = 0
   COLOR = "pink"
   
   def initialize(name)
     @name = name
     @@number_of_cats += 1
   end 
   
   def rename(name)
     self.name = name
   end
   
   def identify
     self
   end
      
   def personal_greeting
     puts "Hello! My name is #{name}"   
   end
   
   def greet
     puts "Hello! My name is #{name} and I'm a #{COLOR} cat!"      
   end 
   
   def to_s
     "I'm #{name}!"    
   end
   
   def self.generic_greeting
     puts "Hello! I'm a cat!"
   end
   
   def self.total
     puts @@number_of_cats   
   end
end

Cat.generic_greeting

# What happens if you run kitty.class.generic_greeting?
kitty = Cat.new('Sophie')
kitty.class.generic_greeting

=begin
Answer: Calling kitty.class will return the class name of the 
kitty instance, which is Cat. Cat.generic_greeting will
Call the class method and print "Hello! I'm a cat!"
=end

#p kitty.name
#kitty.rename('Chloe')
#p kitty.name
#p kitty.identify
kitty.personal_greeting

kitty1 = Cat.new('Mary')
Cat.total

kitty1.greet
puts kitty1