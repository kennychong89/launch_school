# Launch School 
# Lesson 4: OO Exercises Easy 2
# Kenny Chong
# 08/21/2016 6:54 PM

# 1. Given the following code:
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end
  
  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]  
  end
end

# What is the result of calling
oracle = Oracle.new
p oracle.predict_the_future

# Answer: Either
# a) You will eat a nice lunch
# b) You will take a nap soon
# c) You will stay at work late

# 2. We have an Oracle class and a RoadTrip class that inherits from the
# Oracle class.
class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

# What is the result of the following:
trip = RoadTrip.new
p trip.predict_the_future

# Answer: Either
# a) You will visit Vegas
# b) You will fly to Fiji
# c) You will romp in Rome

# 3. How do you find where Ruby will look for a method when that method
# is called? How can you find an object's ancestors?
module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste  
end

class HotSauce
  include Taste
end

# What is the lookup chain for Orange and HotSauce?
# Orange -> Taste -> Object -> Kernel -> BasicObject
# HotSauce -> Taste -> Object -> Kernel -> BasicObject

# 4. What could you add to this class to simplify it and remove two methods
# from the class definition while still maintaining the same functionality?
class BeesWax
  #Answer:
  attr_accessor :type
  
  def initialize(type)
    @type = type
  end

  #def type
  #  @type
  #end

  #def type=(t)
  #  @type = t
  #end

  def describe_type
    #puts "I am a #{@type} of Bees Wax"
    puts "I am a #{type} type of Bees Wax"
  end
end

# 5. There are a number of variables listed below. What are the different
# types and how do you know which is which?
# excited_dog = "excited dog"
# @excited_dog = "excited dog"
# @@excited_dog = "excited dog"

# Answer: 
# excited_dog is a local variable
# @excited_dog is an instance variable because of @
# @@excited_dog is an class variable because of @@

# 6. If I have the following class:
class Television
  def self.manufacturer
  end
  
  def model
  end
end

# Which one these is a class method (if any) and how do you know?
# How would you call a class method?
# If a method name is prefixed with a self., then it is a class method.
# You call a class method by Classname.class_method_name. 
# Ex: Television.manufacturer

# 7. If we have a class such as the one below:
class Cat
  @@cats_count = 0
  
  def initialize(type)
    @type = type
    @age = 0 
    @@cats_count += 1
  end 
  
  def self.cats_count
    @@cats_count  
  end
end

# Explain what the @@cats_count variable does and how it works. What code
# would you need to write to test your theory?

# Answer: The @@cats_count variable will increment itself by 1 everytime a 
# Cat object is created. To test it:
Cat.cats_count # 0
Cat.new("Persian")        
Cat.cats_count # 1
butters = Cat.new("Short-hair") 
Cat.new("Tabby")
Cats.cats_count # 3

# 8. If we have this class:
class Game
  def play
    "Start the game!"  
  end
end

# And another class:
class Bingo
  def rules_of_play
    # rules of play  
  end
end

# What can we add to the Bingo class to allow it to inherit the play method
# from the Game class?

# Answer: 
class Bingo < Game
  def rules_of_play
  end
end

# 9. If we have this class:
class Game
   def play
      "Start the game!"
   end
end

class Bingo < Game
  def rules_of_play
  end  
end

# What would happen if added a play method to the Bingo class, keeping in mind
# that there is already a method of this name in the Game class that the Bingo
# class inherits from.

# Answer: The Bingo class will override the play method from the Game class:
class Game
   def play
      "Start the game!"
   end
end

class Bingo < Game
  def rules_of_play
  end
  
  def play
    "Bingo was its name-o."
  end
end

b = Bingo.new
b.play # "Bingo was its name-o." instead of "Start the game!"

# 10. What are the benefits of using Object Oriented Programming in Ruby?
# Think of as many as you can.
# Answer:
# Better code reuse and management, especially in context of larger software application.

# Ideas of abstraction and encapsulation, meaning not worry about how the class
# inners are implemented, but rather how to use the class interface instead.

# Thinking how classes and objects are represented as real world objects, making
# it easier to design programs.