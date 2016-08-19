# Question 1
# Every named entity in Ruby has an object_id. This is a unique identifier for that object.
# It is often the case that two different things "look the same", but they can be different objects. 
# The "under the hood" object referred to by a particular named-variable can change depending on what is done to that named-variable.
# In other words, in Ruby everything is an object...but it is not always THE SAME object.
# Predict how the values and object ids will change throughout the flow of the code below:
def fun_with_ids
  a_outer = 42           # Assign Arbitary ID: 123
  b_outer = "forty two"  # Assign Arbitary ID: 345
  c_outer = [42]         # Assign Arbitary ID: 678
  d_outer = c_outer[0]   # Assign Arbitary ID: 910

  a_outer_id = a_outer.object_id # a_outer_id = 123 
  b_outer_id = b_outer.object_id # b_outer_id = 345
  c_outer_id = c_outer.object_id # c_outer_id = 678
  d_outer_id = d_outer.object_id # d_outer_id = 910

  puts "a_outer is #{a_outer} with an id of: #{a_outer_id} before the block."
  puts "b_outer is #{b_outer} with an id of: #{b_outer_id} before the block."
  puts "c_outer is #{c_outer} with an id of: #{c_outer_id} before the block."
  puts "d_outer is #{d_outer} with an id of: #{d_outer_id} before the block.\n\n"
  
  # "a_outer is 42 with an id of: 123 before the block."
  # "b_outer is 'forty two' with an id of: 345 before the block."
  # "c_outer is [42] with an id of: 678 before the block."
  # "d_outer is 42 with an id of: 910 before the block."
  
  1.times do
    a_outer_inner_id = a_outer.object_id # a_outer_inner_id = 123
    b_outer_inner_id = b_outer.object_id # b_outer_inner_id = 345
    c_outer_inner_id = c_outer.object_id # c_outer_inner_id = 678
    d_outer_inner_id = d_outer.object_id # d_outer_inner_id = 910

    puts "a_outer id was #{a_outer_id} before the block and is: #{a_outer_inner_id} inside the block."
    puts "b_outer id was #{b_outer_id} before the block and is: #{b_outer_inner_id} inside the block."
    puts "c_outer id was #{c_outer_id} before the block and is: #{c_outer_inner_id} inside the block."
    puts "d_outer id was #{d_outer_id} before the block and is: #{d_outer_inner_id} inside the block.\n\n"

    # "a_outer id was 123 before the block and is: 123 inside the block."
    # "b_outer id was 345 before the block and is: 345 inside the block."
    # "c_outer id was 678 before the block and is: 678 inside the block."
    # "d_outer id was 910 before the block and is: 910 inside the block.\n\n"
    
    a_outer = 22              # new id: 321
    b_outer = "thirty three"  # new id: 543
    c_outer = [44]            # new id: 876
    d_outer = c_outer[0]      # new id: 019

    puts "a_outer inside after reassignment is #{a_outer} with an id of: #{a_outer_id} before and: #{a_outer.object_id} after."
    puts "b_outer inside after reassignment is #{b_outer} with an id of: #{b_outer_id} before and: #{b_outer.object_id} after."
    puts "c_outer inside after reassignment is #{c_outer} with an id of: #{c_outer_id} before and: #{c_outer.object_id} after."
    puts "d_outer inside after reassignment is #{d_outer} with an id of: #{d_outer_id} before and: #{d_outer.object_id} after.\n\n"

    # "a_outer inside after reassignment is 22 with an id of: 123 before and: 321 after."
    # "b_outer inside after reassignment is 'thirty three' with an id of: 345 before and: 543 after."
    # "c_outer inside after reassignment is [44] with an id of: 678 before and: 876 after."
    # "d_outer inside after reassignment is 44 with an id of: 910 before and: 019 after."

    a_inner = a_outer # id: 321
    b_inner = b_outer # id: 543
    c_inner = c_outer # id: 876
    d_inner = c_inner[0] # id: 019

    a_inner_id = a_inner.object_id # 321
    b_inner_id = b_inner.object_id # 543
    c_inner_id = c_inner.object_id # 876
    d_inner_id = d_inner.object_id # 019

    puts "a_inner is #{a_inner} with an id of: #{a_inner_id} inside the block (compared to #{a_outer.object_id} for outer)."
    puts "b_inner is #{b_inner} with an id of: #{b_inner_id} inside the block (compared to #{b_outer.object_id} for outer)."
    puts "c_inner is #{c_inner} with an id of: #{c_inner_id} inside the block (compared to #{c_outer.object_id} for outer)."
    puts "d_inner is #{d_inner} with an id of: #{d_inner_id} inside the block (compared to #{d_outer.object_id} for outer).\n\n"

    # "a_inner is 22 with an id of: 321 inside the block (compared to 321 for outer)."
    # "b_inner is 'thirty three' with an id of: 543 inside the block (compared to 543 for outer)."
    # "c_inner is [44] with an id of: 876 inside the block (compared to 876 for outer)."
    # "d_inner is 44 with an id of: 019 inside the block (compared to 019 for outer).\n\n"
  end

  puts "a_outer is #{a_outer} with an id of: #{a_outer_id} BEFORE and: #{a_outer.object_id} AFTER the block."
  puts "b_outer is #{b_outer} with an id of: #{b_outer_id} BEFORE and: #{b_outer.object_id} AFTER the block."
  puts "c_outer is #{c_outer} with an id of: #{c_outer_id} BEFORE and: #{c_outer.object_id} AFTER the block."
  puts "d_outer is #{d_outer} with an id of: #{d_outer_id} BEFORE and: #{d_outer.object_id} AFTER the block.\n\n"
  
  # puts "a_outer is 22 with an id of: 123 BEFORE and: 321 AFTER the block."
  # puts "b_outer is 'thirty three' with an id of: 345 BEFORE and: 543 AFTER the block."
  # puts "c_outer is [44] with an id of: 678 BEFORE and: 876 AFTER the block."
  # puts "d_outer is #{d_outer} with an id of: 910 BEFORE and: 019 AFTER the block.\n\n"

  puts "a_inner is #{a_inner} with an id of: #{a_inner_id} INSIDE and: #{a_inner.object_id} AFTER the block." rescue puts "ugh ohhhhh"
  puts "b_inner is #{b_inner} with an id of: #{b_inner_id} INSIDE and: #{b_inner.object_id} AFTER the block." rescue puts "ugh ohhhhh"
  puts "c_inner is #{c_inner} with an id of: #{c_inner_id} INSIDE and: #{c_inner.object_id} AFTER the block." rescue puts "ugh ohhhhh"
  puts "d_inner is #{d_inner} with an id of: #{d_inner_id} INSIDE and: #{d_inner.object_id} AFTER the block.\n\n" rescue puts "ugh ohhhhh"
  # All "ugh oohhhhh"
end

# Question 2
# Let's look at object id's again from the perspective of a method call instead of a block.
# Here we haven't changed ANY of the code outside of inside of the block/method. 
# We simply took the contents of the block from the previous exercise and moved it to a method, to which we are passing all of our outer variables.
# Predict how the values and object ids will change throughout the flow of the code below:
def fun_with_ids_2
  a_outer = 42
  b_outer = "forty two"
  c_outer = [42]
  d_outer = c_outer[0]

  a_outer_id = a_outer.object_id
  b_outer_id = b_outer.object_id
  c_outer_id = c_outer.object_id
  d_outer_id = d_outer.object_id

  # a_outer_inner_id = 123
  # b_outer_inner_id = 345
  # c_outer_inner_id = 678
  # d_outer_inner_id = 123

  puts "a_outer is #{a_outer} with an id of: #{a_outer_id} before the block."
  puts "b_outer is #{b_outer} with an id of: #{b_outer_id} before the block."
  puts "c_outer is #{c_outer} with an id of: #{c_outer_id} before the block."
  puts "d_outer is #{d_outer} with an id of: #{d_outer_id} before the block.\n\n"

  # "a_outer is 42 with an id of: 123 before the block."
  # "b_outer is 'forty two' with an id of: 345 before the block."
  # "c_outer is [42] with an id of: 678 before the block."
  # "d_outer is 42 with an id of: 123 before the block."

  an_illustrative_method(a_outer, b_outer, c_outer, d_outer, a_outer_id, b_outer_id, c_outer_id, d_outer_id)

  puts "a_outer is #{a_outer} with an id of: #{a_outer_id} BEFORE and: #{a_outer.object_id} AFTER the method call."
  puts "b_outer is #{b_outer} with an id of: #{b_outer_id} BEFORE and: #{b_outer.object_id} AFTER the method call."
  puts "c_outer is #{c_outer} with an id of: #{c_outer_id} BEFORE and: #{c_outer.object_id} AFTER the method call."
  puts "d_outer is #{d_outer} with an id of: #{d_outer_id} BEFORE and: #{d_outer.object_id} AFTER the method call.\n\n"
  # Same ids as before the method call

  puts "a_inner is #{a_inner} with an id of: #{a_inner_id} INSIDE and: #{a_inner.object_id} AFTER the method." rescue puts "ugh ohhhhh"
  puts "b_inner is #{b_inner} with an id of: #{b_inner_id} INSIDE and: #{b_inner.object_id} AFTER the method." rescue puts "ugh ohhhhh"
  puts "c_inner is #{c_inner} with an id of: #{c_inner_id} INSIDE and: #{c_inner.object_id} AFTER the method." rescue puts "ugh ohhhhh"
  puts "d_inner is #{d_inner} with an id of: #{d_inner_id} INSIDE and: #{d_inner.object_id} AFTER the method.\n\n" rescue puts "ugh ohhhhh"
  # All ugh ohhhh
end


def an_illustrative_method(a_outer, b_outer, c_outer, d_outer, a_outer_id, b_outer_id, c_outer_id, d_outer_id)
  a_outer_inner_id = a_outer.object_id 
  b_outer_inner_id = b_outer.object_id
  c_outer_inner_id = c_outer.object_id
  d_outer_inner_id = d_outer.object_id

  # a_outer_inner_id = 123
  # b_outer_inner_id = 345
  # c_outer_inner_id = 678
  # d_outer_inner_id = 123

  puts "a_outer id was #{a_outer_id} before the method and is: #{a_outer.object_id} inside the method."
  puts "b_outer id was #{b_outer_id} before the method and is: #{b_outer.object_id} inside the method."
  puts "c_outer id was #{c_outer_id} before the method and is: #{c_outer.object_id} inside the method."
  puts "d_outer id was #{d_outer_id} before the method and is: #{d_outer.object_id} inside the method.\n\n"
 
  # a_outer id was 123 before the method and is: 123 inside the method.
  # b_outer id was 345 before the method and is: 345 inside the method.
  # c_outer id was 678 before the method and is: 678 inside the method.
  # d_outer id was 123 before the method and is: 123 inside the method.

  a_outer = 22 
  b_outer = "thirty three"
  c_outer = [44]
  d_outer = c_outer[0]

  # Arbitary ids:
  # a_outer.object_id = abc
  # b_outer.object_id = def
  # c_outer.object_id = hij
  # d_outer.object_id = klm

  puts "a_outer inside after reassignment is #{a_outer} with an id of: #{a_outer_id} before and: #{a_outer.object_id} after."
  puts "b_outer inside after reassignment is #{b_outer} with an id of: #{b_outer_id} before and: #{b_outer.object_id} after."
  puts "c_outer inside after reassignment is #{c_outer} with an id of: #{c_outer_id} before and: #{c_outer.object_id} after."
  puts "d_outer inside after reassignment is #{d_outer} with an id of: #{d_outer_id} before and: #{d_outer.object_id} after.\n\n"

  # a_outer inside after reassignment is 22 with an id of: 123 before and abc after.
  # b_outer inside after reassignment is thirty three with an id of: 345 before and def after.
  # c_outer inside after reassignment is [44] with an id of: 678 before and hij after.
  # d_outer inside after reassignment is 44 with an id of: 123 before and klm after.

  a_inner = a_outer
  b_inner = b_outer
  c_inner = c_outer
  d_inner = c_inner[0]

  a_inner_id = a_inner.object_id
  b_inner_id = b_inner.object_id
  c_inner_id = c_inner.object_id
  d_inner_id = d_inner.object_id

  # a_inner_id = abc
  # b_inner_id = def
  # c_inner_id = hij
  # d_inner_id = klm

  puts "a_inner is #{a_inner} with an id of: #{a_inner_id} inside the method (compared to #{a_outer.object_id} for outer)."
  puts "b_inner is #{b_inner} with an id of: #{b_inner_id} inside the method (compared to #{b_outer.object_id} for outer)."
  puts "c_inner is #{c_inner} with an id of: #{c_inner_id} inside the method (compared to #{c_outer.object_id} for outer)."
  puts "d_inner is #{d_inner} with an id of: #{d_inner_id} inside the method (compared to #{d_outer.object_id} for outer).\n\n"

  # a_inner is 22 with an id of: abc inside the method (compared to abc for outer)
  # b_inner is thirty three with an id of: abc inside the method (compared to def for outer)
  # c_inner is [44] with an id of: hij inside the method (compared to hij for outer)
  # d_inner is 44 with and id of: klm inside the method (compared to klm for outer)
end

# Question 3
# Let's call a method, and pass both a string and an array as parameters and see how even though they are treated in the same way by Ruby, the results can be different.
# Study the following code and state what will be displayed...and why:

def tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param << "rutabaga"
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"

# Solution: 
# My string looks like this now: pumpkins
# My array looks like this now: ["pumpkins", "rutabaga"]
# Reason, for the string, when you pass my_string as argument to tricky_method, tricky_method will copy the string value to a_string_param. 
#         the concatentation of a_string_param and "rutabaga" will create a new string value assigned to local variable a_string_param.
#         for the array, when you pass my_array as argument to tricky_method, tricky_method will reference the array object to an_array_param. 
#         any changes made to the an_array_param will affect the actual array object itself.


# Question 4
# To drive that last one home...let's turn the tables and have the string show a modified output, 
# while the array thwarts the method's efforts to modify the caller's version of it.
def tricky_method_two(a_string_param, an_array_param)
  a_string_param.gsub!('pumpkins', 'rutabaga')
  an_array_param = ['pumpkins', 'rutabaga']
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method_two(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"

# Solution:
# My string looks like this now: rutabaga
# My array looks like this now: ["pumpkins"]

# Question 5
# How could the unnecessary duplication in this method be removed?
def color_valid(color)
  if color == "blue" || color == "green"
    true
  else
    false
  end
end

# Solution
def color_valid(color)
  color == "blue" || color == "green"
end