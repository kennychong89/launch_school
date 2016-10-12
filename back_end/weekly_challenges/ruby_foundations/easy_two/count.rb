=begin
OO Exercises
Launch School
Kenny Chong 
10/10/2016 6:45 PM

https://launchschool.com/exercises/c6c0d9a9
=end

def count(arr)
  arr.inject(0) do |total, value|
    yield(value) ? total + 1 : total  
  end
end

p count([1, 3, 6]) { |value| value.odd? } == 2
p count([1, 3, 6]) { |value| value.even? } == 1
p count([1, 3, 6]) { |value| value > 6 } == 0
p count([1, 3, 6]) { |value| true } == 3
p count([]) { |value| true } == 0
p count([1, 3, 6]) { |value| value - 6 } == 3