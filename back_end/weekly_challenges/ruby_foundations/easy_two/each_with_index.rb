=begin
OO Exercises
Launch School
Kenny Chong 
10/12/2016 2:34 PM

https://launchschool.com/exercises/12e1e19c
=end

def each_with_index(arr)
   index = 0
   while index < arr.size
     yield(arr[index], index) if block_given?
     index += 1
   end
   arr
end

result = each_with_index([1, 3, 6]) do |value, index|
  puts "#{index} -> #{value**index}"
end

puts result == [1, 3, 6]