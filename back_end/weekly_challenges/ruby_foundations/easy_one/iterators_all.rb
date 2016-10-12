=begin
OO Exercises
Launch School
Kenny Chong 
10/09/2016 10:03 PM

https://launchschool.com/exercises/9c2b1d27
=end

def all?(arr)
  arr.each do |ele|
    if block_given?
      return false unless yield(ele)
    end
  end
  true
end

p all?([1, 3, 5, 6]) { |value| value.odd? } == false
p all?([1, 3, 5, 7]) { |value| value.odd? } == true
p all?([2, 4, 6, 8]) { |value| value.even? } == true
p all?([1, 3, 5, 7]) { |value| value % 5 == 0 } == false
p all?([1, 3, 5, 7]) { |value| true } == true
p all?([1, 3, 5, 7]) { |value| false } == false
p all?([]) { |value| false } == true