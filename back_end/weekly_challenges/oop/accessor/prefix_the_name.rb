=begin
OO Exercises
Launch School
Kenny Chong 
10/03/2016 9:38 PM

Using the following code, add the appropriate accessor methods 
so that @name is returned with the added prefix 'Mr.'.

class Person
end

person1 = Person.new
person1.name = 'James'
puts person1.name

Expected output:

Mr. James
=end

class Person
  attr_writer :name
  
  def name
    "Mr. #{@name}" 
  end 
end

person1 = Person.new
person1.name = 'James'
puts person1.name

