=begin
OO Exercises
Launch School
Kenny Chong 
10/10/2016 6:15 PM

https://launchschool.com/exercises/7c6be14d
=end

def zip(arr_one, arr_two)
  (0..arr_one.size - 1).map { |index| [arr_one[index], arr_two[index]] }
end

p zip([1, 2, 3], [4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]
p zip([3, 2], [5,7])