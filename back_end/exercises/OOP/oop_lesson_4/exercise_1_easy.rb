# Launch School 
# Lesson 4: OO Exercises Easy 1
# Kenny Chong
# 08/21/2016 3:15 PM

# 1. Which of the following are objects in Ruby? If they are objects,
# how can you find out what class they belong to?
true                        # an object. TrueClass
"hello"                     # an object. String Class
[1, 2, 3, "happy days"]     # an object. Array Class
142                         # an object. Fixnum Class

# 2. If we have a Car class and a Truck class and we want to be able to 
# go_fast, how can we add the ability for them to go_fast using the module 
# Speed? How can you check if you Car or Truck can now go fast?
module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed # add this
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed  # add this
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

Car.new.go_fast
Truck.new.go_fast

# 3. In the last question we had a module called Speed which contained a go_fast
# method. We included this module in the Car class as show above.
# When we called the go_fast method from an instance of the Car class you
# might have noticed the string printed when we go includes the name of the type
# of vehicle we are using. How is this done?

# Answer: Inside the Speed module method go_fast, there is an output generated
# by puts. There is also a #{self.class} expression, which I assume the module
# will look at the inheritance hierarchy and see which class is using the module.
# The self.class will be replaced by the class name, which would be Car.

# 4. If we have a class AngryCat how do we create a new instance of this class?
# The AngryCat class might look something like this:
class AngryCat
  def hiss
    puts "Hissssss!!!" 
  end
end

# Answer:
garfield = AngryCat.new
garfield.hiss

# 5. Which of these two classes has an instance variable and how do you know?
class Fruit
  def initialize(name)
    name = name  
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# Answer: @name in Pizza because of the @.

# 6. What could we add to the class below to access the instance variable
# @volume?
class Cube
  # Answer:
  attr_reader :volume
  
  def initialize(volume)
    @volume = volume
  end
  
  # Also: 
  # def get_volume 
  #   @volume
  # end
end

cube = Cube.new(3)
p cube.volume

# 7. What is the default thing that Ruby will print to the screen if you call
# to_s on an object? Where could you go to find out to be sure?
# Answer: to_s will print out the object's address in memory, usually in a
# form of hexidecimal.
# To be sure, you can type 'p object_name' or 'puts object_name'

# 8. If we have a class such as the one below:
class Cat
  attr_accessor :type, :age
  
  def initialize(type)
    @type = type
    @age = 0
  end
  
  def make_one_year_older
    self.age += 1 
  end
end

# You can see in the make_one_year_older method we have used self. What does
# self refer to here?
# Answer: self refer to the object that is calling the age setter method and
# the make_one_year_older method.

# 9. If we have a class such as the one below:
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

# In the name of the cats_count method we have used self. What does self
# refer to in this context?
# Answer: self refers to the class (not object) that is calling cats_count,
# which in this case would be the Cat class. It is a class method.

# Question 10
# If we have the class below, what would you need to call to create a new 
# instance of this class.
class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

# Answer:
gucci_bag = Bag.new("Blue", "Leather")
