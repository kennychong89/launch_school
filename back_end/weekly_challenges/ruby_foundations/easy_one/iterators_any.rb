=begin
OO Exercises
Launch School
Kenny Chong 
10/09/2016 10:09 PM

https://launchschool.com/exercises/944b8310
=end

def any?(arr)
  arr.each do |ele|
    if block_given?
      return true if yield(ele)
    end
  end
  false
end

p any?([1, 3, 5, 6]) { |value| value.even? } == true
p any?([1, 3, 5, 7]) { |value| value.even? } == false
p any?([2, 4, 6, 8]) { |value| value.odd? } == false
p any?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
p any?([1, 3, 5, 7]) { |value| true } == true
p any?([1, 3, 5, 7]) { |value| false } == false
p any?([]) { |value| true } == false
