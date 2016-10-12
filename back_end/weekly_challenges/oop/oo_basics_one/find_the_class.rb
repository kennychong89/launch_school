=begin
Modify the following code so that, instead of printing the values, 
each statement prints the name of the class it belongs to.

puts 'Hello'
puts 5
puts [1, 2, 3]

Expected output:

String
Fixnum
Array
=end

puts 'Hello'.class
puts 5.class
puts [1, 2, 3].class