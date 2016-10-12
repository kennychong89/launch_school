=begin
OO Exercises
Launch School
Kenny Chong 
10/06/2016 9:56 PM

https://launchschool.com/exercises/c610de82
=end

class FixedArray
  def initialize(size)
    @fixed_array = Array.new(size)  
  end
  
  def [](index)
    raise IndexError if out_of_range?(index)  
    fixed_array[index]  
  end
  
  def []=(index, item)
    raise IndexError if out_of_range?(index)
    fixed_array[index] = item
  end
  
  def to_a
    fixed_array.clone
  end
  
  def to_s
    fixed_array.to_s  
  end
  
  private
  
  attr_reader :fixed_array
  
  def out_of_range?(index)
    index.abs > fixed_array.size 
  end
end 

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end
