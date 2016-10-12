=begin
OO Exercises
Launch School
Kenny Chong 
10/10/2016 6:23 PM

https://launchschool.com/exercises/8341f1f1
=end

def map(arr)
   mapped_items = []
   arr.each do |item|
     mapped_items.push(yield(item)) if block_given?       
   end
   mapped_items
end

p map([1, 3, 6]) { |value| value**2 } == [1, 9, 36]
p map([]) { |value| true } == []
p map(['a', 'b', 'c', 'd']) { |value| false } == [false, false, false, false]
p map(['a', 'b', 'c', 'd']) { |value| value.upcase } == ['A', 'B', 'C', 'D']
p map([1, 3, 4]) { |value| (1..value).to_a } == [[1], [1, 2, 3], [1, 2, 3, 4]]
