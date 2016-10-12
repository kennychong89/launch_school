=begin
OO Exercises
Launch School
Kenny Chong 
10/03/2016 9:54 PM

Modify the following code to accept a string containing 
a first and last name. The name should be split 
into two instance variables in the setter method, 
then joined in the getter method to form a full name.

class Person
  attr_accessor :name
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name

Expected output:

John Doe
=end

class Person
  def name=(name)
    @first_name, @last_name = name.split(' ')
  end
  
  def name
    "#{@first_name} #{@last_name}"  
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name