=begin
OO Exercises
Launch School
Kenny Chong 
10/09/2016 10:08 PM

https://launchschool.com/exercises/11204cc9
=end

def none?(arr)
  arr.each do |ele|
    if block_given?
      return false if yield(ele)
    end
  end
  true
end

p none?([1, 3, 5, 6]) { |value| value.even? } == false
p none?([1, 3, 5, 7]) { |value| value.even? } == true
p none?([2, 4, 6, 8]) { |value| value.odd? } == true
p none?([1, 3, 5, 7]) { |value| value % 5 == 0 } == false
p none?([1, 3, 5, 7]) { |value| true } == false
p none?([1, 3, 5, 7]) { |value| false } == true
p none?([]) { |value| true } == true