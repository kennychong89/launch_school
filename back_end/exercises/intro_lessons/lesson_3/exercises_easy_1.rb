# Question 1
# What would you expect the code below to print out?
numbers = [1, 2, 2, 3]
numbers.uniq

puts numbers
# Answer: [1,2,2,3] since numbers.uniq generated a new array instead of modifying the old one.

# Question 2
# Describe the difference between ! and ? in Ruby. And explain what would happen in the following scenarios: 
# 1. what is != and where should you use it? 
# 2. put ! before something, like !user_name 
# 3. put ! after something, like words.uniq! 
# 4. put ? before something 
# 5. put ? after something 
# 6. put !! before something, like !!user_name
# Answer: I think ! modifies the data of the container, such as numbers.uniq! phyiscally removes duplicates from number array.
#         ? asks if the whatever is true or not.
# 1) != means not equal and is part of a conditional expression.
# 2) ! means negation. for example if user_name = false, then !user_name is true.
# 3) ! like in words.uniq! modifies the string, array, object, ect., but does not create a new copy with the modifications.
# 4) Doesn't do anything
# 5) Doesn't do anything
# 6) Double negation?

# Question 3
# Replace the word "important" with "urgent" in this string.
advice = "Few things in life are as important as house training your pet dinosaur."
# Answer: advice.sub("important", "urgent") .sub only replaces the first occurrence
# Also: advice.gsub!("important", "urgent") .gsub replaces all occurrences

# Question 4
# The Ruby Array class has several methods for removing items from the array. 
# Two of them have very similar names. Let's see how they differ:
numbers = [1, 2, 3, 4, 5]

# What does the follow method calls do (assume we reset numbers to the original array between method calls)?
numbers.delete_at(1)
numbers.delete(1)

# Answer: numbers.delete_at(1) deletes the element at index 1
#         numbers.delete(1) deletes the all occurrences of the number 1 in the array

# Question 5
# Programmatically determine if 42 lies between 10 and 100.

# hint: Use Ruby's range object in your solution.
# Answer:
for i in 10..100
  if i == 42
    puts "42 is between 10 and 100"
    break
  end
end

# Another Answer: (10..100).cover?(42)

# Question 6
# Starting with the string:

# famous_words = "seven years ago..."

# show two different ways to put the expected "Four score and " in front of it.
# Answer:
"Four score and " + famous_words
"Four score and ".concat(famous_words)
famous_words.prepend("Four score and ")

# Question 7 
# Fun with gsub
def add_eight(number)
  number + 8
end

number = 2

how_deep = "number"
5.times { how_deep.gsub!("number", "add_eight(number)") }

p how_deep

# This gives us a string that looks like a "recursive" method call:

# "add_eight(add_eight(add_eight(add_eight(add_eight(number)))))"

# If we take advantage of Ruby's Kernel#eval method to have it execute this string as if it were a "recursive" method call

eval(how_deep)

# what will be the result?
# Answer: 42

# Question 8
#If we build an array like this:

flintstones = ["Fred", "Wilma"]
flintstones << ["Barney", "Betty"]
flintstones << ["BamBam", "Pebbles"]

# We will end up with this "nested" array:
# ["Fred", "Wilma", ["Barney", "Betty"], ["BamBam", "Pebbles"]]

# Make this into an un-nested array.
# Answer: flintstones.flatten

# Question 9
# Given the hash below

# flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }

# Turn this into an array containing only two elements: Barney's name and Barney's number
# Answer: 
# flintstones.select do |k,v|
#   k == "Barney"
# end.to_a.flatten
# Shorter Answer: flintstones.assoc("Barney")

# Question 10
# Given the array below

# flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

# Turn this array into a hash where the names are the keys and the values are the positions in the array.
# Answer:
# new_hash = {}
# flintstones.each_with_index do |i,v|
#  new_hash[i] = v
# end 