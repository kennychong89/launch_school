=begin
OO Exercises
Launch School
Kenny Chong 
10/10/2016 6:45 PM

https://launchschool.com/exercises/f9cb9ad5
=end

def drop_while(arr)
  index = 0
  arr.each do |item|
    break unless yield(item)
    index += 1
  end
  arr.slice(index..-1)
end

p drop_while([1, 3, 5, 6]) { |value| value.odd? } == [6]
p drop_while([1, 3, 5, 6]) { |value| value.even? } == [1, 3, 5]
p drop_while([1, 3, 5, 6]) { |value| true } == []
p drop_while([1, 3, 5, 6]) { |value| false } == [1, 3, 5, 6]
p drop_while([1, 3, 5, 6]) { |value| value < 5 } == [5, 6]
p drop_while([]) { |value| true } == []