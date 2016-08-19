# Question 1
# Let's do some "ASCII Art" (a stone-age form of nerd artwork from back in the days before computers had video screens).
# For this exercise, write a one-line program that creates the following output 10 times, with the subsequent line indented 1 space to the right:
# The Flintstones Rock!
#  The Flintstones Rock!
#   The Flintstones Rock!
# Answer: 
10.times {|i| puts "The Flintstones Rock!".prepend(" " * i)} 

# Question 2
# Create a hash that expresses the frequency with which each letter occurs in this string:
statement = "The Flintstones Rock"
# ex:
#{ "F"=>1, "R"=>1, "T"=>1, "c"=>1, "e"=>2, ... }
# Answer:
frequency = {}
statement = "The Flintstones Rock"
statement.delete(' ').split('').each do |c|
  if !frequency.key?(c) # frequency[c] = 1 if !frequency.key?(c) else frequency[c] += 1
    frequency[c] = 1
  else 
    frequency[c] += 1
  end
end

# Question 3
# The result of the following statement will be an error:
puts "the value of 40 + 2 is " + (40 + 2)

# Why is this and what are two possible ways to fix this?
# Answer: (40 + 2) results in an integer type, which will cause an exception when concated with a string type.
# Solution 1: 
puts "the value of 40 + 2 is " + (40 + 2).to_s
# Solution 2:
puts "the value of 40 + 2 is #{(40 + 2)}"

# Question 4
# What happens when we modify an array while we are iterating over it? What would be the output by this code?
numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

# Answer: It will provide inconsistent results. The resulting code will print 1,3.

# What would be output by this code?
numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end

# Answer: 1,2

# Question 5
# Alan wrote the following method, which was intented to show all factors of the input number
def factors(number)
  dividend = number
  divisors = []
  begin
    divisors << number / dividend if number % dividend == 0
    dividend -= 1
  end until dividend == 0
  divisors
end

# Alyssa noticed that this will fail if you call this with an input of 0 or a negative number and 
# asked Alan to change the loop. How can you change the loop construct (instead of using begin/end/until)
# to make this work? Note that we're not looking to find factors for 0 or negative numbers, but we 
# just want to handle it gracefully instead of raising an exception or going into an infinite loop.

# Possible solution:
def factors(number)
  dividend = number
  divisors = []

  while dividend > 0
    divisors << number / dividend if number % dividend == 0
    dividend -= 1 
  end
  divisors
end

# Bonus 1: What is the purpose of the number % dividend == 0?
# Answer: Checks if number is divisible by the dividend because factors of the number should not leave any remainders.

# Bonus 2: What is the purpose of the second-to-last line in the method (the divisors before the method's end)?
# Answer: Tells method to return the divisors array. 

# Question 6
# Alyssa was asked to write an implementation of a rolling buffer. Elements are added to the rolling buffer and if the
# buffer becomes full, then new elements that are added will displace the oldest elements in the buffer.

# She wrote two implementation saying. "Take your pick. Do you like << or + for modifying the buffer?". Is there a
# difference between the two, other than what operator she chose to use to add an element to the buffer?
def rolling_buffer1(buffer, max_buffer_size, new_element)
  buffer << new_element
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

def rolling_buffer2(input_array, max_buffer_size, new_element)
  buffer = input_array + [new_element]
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

# Solution: There doesn't seems to be any difference. I assume input_array + [new_element] copies all elements to a new array, whereas << doesn't create a new array.
# From those ideas, << seems to be a bit more efficient.
# Also:
[1,2,3] << [1,2,3] # [1,2,3, [1,2,3]]
[1,2,3] + [1,2,3]  # [1,2,3,1,2,3]

# Actual Solution : 
# Yes, there is a difference. While both methods have the same return value, in the first implementation, 
# the input argument called buffer will be modified and will end up being changed after rolling_buffer1 returns. That is, 
# the caller will have the input array that they pass in be different once the call returns. 
# In the other implementation, rolling_buffer2 will not alter the caller's input argument.

# Question 7
# Alyssa asked Ben to write up a basic implementation of a Fibonacci calculator, 
# A user passes in two numbers, and the calculator will keep computing the sequence until some limit is reached.
# Ben coded up this implementation but complained that as soon as he ran it, he got an error. Something about the limit variable. What's wrong with the code
limit = 15

def fib(first_num, second_num)
  while second_num < limit
    sum = first_num + second_num
    first_num = second_num
    second_num = sum
  end
  sum
end

result = fib(0, 1)
puts "result is #{result}"

# Solution: The fib method created a new block and therefore the local variable limit has not beeen initialized. The method does not know about the limit variable outside
# its scope.
limit = 15
def fib(first_num, second_num, limit)
  while second_num < limit
    sum = first_num + second_num
    first_num = second_num
    second_num = sum
  end
  sum
end

fib(3,5,limit)

# Question 8
# In another example we used some built-in string methods to change the case of a string. 
# A notably missing method is something provided in Rails, but not in Ruby itself...titleize! 
# This method in Ruby on Rails creates a string that has each word capitalized as it would be in a title.
# Write your own version of the rails titleize implementation.
# Solution:
def titleize(string)
  string.split(' ').map { |s| s.capitalize }.join(' ')
end

# Question 9
# Given the munsters hash below
munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# Modify the hash such that each member of the Munster family has additional "age_group" key that has one of three values
# describing the age group the family member is in (kid, adult, or senior). Your solution should produce the hash below.
{ "Herman" => { "age" => 32, "gender" => "male", "age_group" => "adult" },
  "Lily" => {"age" => 30, "gender" => "female", "age_group" => "adult" },
  "Grandpa" => { "age" => 402, "gender" => "male", "age_group" => "senior" },
  "Eddie" => { "age" => 10, "gender" => "male", "age_group" => "kid" },
  "Marilyn" => { "age" => 23, "gender" => "female", "age_group" => "adult" } }

# Note: a kid is in the age range 0-17, an adult is in the range 18-64, and a senior is aged 65+.
# hint: try using a case statement along with Ruby Range objects in your solution.
munster_family.each do |name, info|
   member_age = info[:age]

   case member_age
   when (0..17).cover?(member_age) then info[:age_group] = "kid"
   when (18..64).cover?(member_age) then info[:age_group] = "adult" 
   else info[:age_group] = "senior"
   end
end