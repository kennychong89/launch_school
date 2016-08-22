# Launch School 
# Lesson 4: OO Exercises Easy 3
# Kenny Chong
# 08/21/2016 8:47 PM

# 1. If we have this code:
class Greeting
   def greet(message)
     puts message 
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

# What happens in each of the following cases:
# case 1:
hello = Hello.new
hello.hi

# Answer: "Hello"

# case 2:
hello = Hello.new
hello.bye 

# Answer: Cannot find method "bye"

# case 3:
hello = Hello.new
hello.greet

# Answer: Missing argument 1 argument needed

# case 4:
hello = Hello.new
hello.greet("Goodbye")

# Answer: "Goodbye"

# case 5:
Hello.hi

# Answer: Cannot find class method "hi"

# 2. In the last question we had the following classes:
class Greeting
  def greet(message)
    puts message
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

# If we call Hello.hi we get an error message. How would you fix this?
# Answer:
class Hello < Greeting
  def self.hi
    greeting = Greeting.new
    greeting.greet("Hello")
  end
end

# 3. When objects are created they are a seperate realization of a particular
# class.

# Given the class below, how do we create two different instances of this class,
# both with separate name and ages?
class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

# Answer:
garfield = AngryCat.new(20, "Garfield")
tom = AngryCat.new(100, "Tom")

# 4. Given the class below, if we created a new instance of the class and the
# called to_s on that instance we would get something like 
# "#<Cat:0x007ff39b356d30>"
class Cat
  def initialize(type)
    @type = type
  end
end

# How could we go about changing the to_s ouput this method to look like this:
# I am a tabby cat? (this is assuming that "tabby" is the type we passed during
# initialization)

# Answer:
class Cat
  attr_reader :type
  
  def initialize(type)
    @type = type
  end
  
  def to_s
    "I am a #{type} cat"  
  end
end

# 5. If I have the following class:
class Television
  def self.manufacturer
  end
  
  def model
  end
end

# What would happen if I called the methods like shown below?
tv = Television.new
tv.manufacturer
tv.model

Television.manufacturer
Television.model

# Answer:
tv.manufacturer # Should produce no error (My answer is wrong, this returns an error)
tv.model        # Should produce no error

Television.manufacturer # Should product no error
Television.model        # Error

# 6. If we have a class such as the one below:
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# In the make_one_year_older method we have used self. What is another way
# we could write this method so we don't have to use the self prefix?
# Answer:
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    @age += 1
  end
end

# 7. What is used in this class but doesn't add any value?
class Light
  attr_accessor :brightness, :color
  
  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end
  
  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"  
  end
end

# Answer: The return clause is not needed.