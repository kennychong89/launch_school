=begin
OO Exercises
Launch School
Kenny Chong 
10/09/2016 10:28 PM

https://launchschool.com/exercises/ea073d36
=end

def count(arr)
   count = 0
   arr.each do |item|
     count += 1 if yield(item)           
   end
   count
end

p count([1,2,3,4,5]) { |value| value.odd? } == 3
p count([1,2,3,4,5]) { |value| value % 3 == 1 } == 2
p count([1,2,3,4,5]) { |value| true } == 5
p count([1,2,3,4,5]) { |value| false } == 0
p count([]) { |value| value.even? } == 0
p count(%w(Four score and seven)) { |value| value.size == 5 } == 2