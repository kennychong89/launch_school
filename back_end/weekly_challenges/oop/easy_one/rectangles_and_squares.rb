=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 9:30 PM


Rectangles and Squares

Given the following class:

class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end

  def area
    @height * @width
  end
end

Write a class called Square that inherits from Rectangle, 
and is used like this:

square = Square.new(5)
puts "area of square = #{square.area}"
=end

class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end
  
  def area
    @height * @width  
  end
end

class Square < Rectangle
  def initialize(length_of_side)
    super(length_of_side, length_of_side)
  end
end

square = Square.new(5)
puts "area of square = #{square.area}"