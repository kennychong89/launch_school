=begin
OO Exercises
Launch School
Kenny Chong 
10/12/2016 2:42 PM

https://launchschool.com/exercises/35a94033
=end

def max_by(arr)
  biggest = nil
  prev = arr.first
  arr.each do |ele|
    biggest = ele if yield(biggest) > prev
    prev = yield(ele)
  end
  biggest
end

p max_by([1, 5, 3]) { |value| value + 2 } == 5
p max_by([1, 5, 3]) { |value| 9 - value } == 1
p max_by([1, 5, 3]) { |value| (96 - value).chr } == 1
p max_by([[1, 2], [3, 4, 5], [6]]) { |value| value.size } == [3, 4, 5]
p max_by([-7]) { |value| value * 3 } == -7
p max_by([]) { |value| value + 5 } == nil