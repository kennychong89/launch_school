=begin
OO Exercises
Launch School
Kenny Chong 
10/09/2016 10:28 PM

https://launchschool.com/exercises/ea073d36
=end

def one?(arr)
  count = 0
  arr.each do |ele|
    if block_given?
      count += 1 if yield(ele)
      return false if count > 1
    end
  end
  count == 1
end

p one?([1, 3, 5, 6]) { |value| value.even? }    # -> true
p one?([1, 3, 5, 7]) { |value| value.odd? }     # -> false
p one?([2, 4, 6, 8]) { |value| value.even? }    # -> false
p one?([1, 3, 5, 7]) { |value| value % 5 == 0 } # -> true
p one?([1, 3, 5, 7]) { |value| true }           # -> false
p one?([1, 3, 5, 7]) { |value| false }          # -> false
p one?([]) { |value| true }                     # -> false