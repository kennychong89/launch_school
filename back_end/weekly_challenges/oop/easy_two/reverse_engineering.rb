=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 10:26 PM

Write a class that will display:

ABC
xyz

when the following code is run:

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')
=end

class Transform
  attr_reader :str
  
  def initialize(str)
    @str = str
  end
  
  def self.lowercase(str)
    str.downcase  
  end
  
  def uppercase
    str.upcase  
  end
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')
