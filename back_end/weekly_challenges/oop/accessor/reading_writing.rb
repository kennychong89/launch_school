=begin
OO Exercises
Launch School
Kenny Chong 
10/03/2016 8:57 PM

Add the appropriate accessor methods to the following code.

class Person
end

person1 = Person.new
person1.name = 'Jessica'
puts person1.name

Expected output:

Jessica
=end

class Person
  attr_accessor :name
end

person1 = Person.new
person1.name = 'Jessica'
puts person1.name
