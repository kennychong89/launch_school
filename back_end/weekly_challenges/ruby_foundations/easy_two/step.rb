=begin
OO Exercises
Launch School
Kenny Chong 
10/10/2016 6:08 PM

https://launchschool.com/exercises/ec8dd514
=end

def step(start_point, end_point, increment)
  value = start_point
  range = []
  while value <= end_point
    yield(value) if block_given?
    range.push(value)
    value += increment
  end
  range # return the range of values
end

r = step(1, 10, 3) { |value| puts "value = #{value}" }
p r 

