=begin
OO Exercises
Launch School
Kenny Chong 
10/03/2016 9:09 PM

Using the following code, add the appropriate accessor methods. 
Keep in mind that @age should only be visible to instances of Person.

class Person
  def older_than?(other)
    age > other.age
  end
end

person1 = Person.new
person1.age = 17

person2 = Person.new
person2.age = 26

puts person1.older_than?(person2)

Expected output:

false
=end

class Person
  attr_writer :age
  
  def older_than?(other)
    age > other.age
  end
  
  protected
  
  attr_reader :age
end

person1 = Person.new
person1.age = 17

person2 = Person.new
person2.age = 26

puts person1.older_than?(person2)

# When a method is private, only the class - not instances of the class 
# - can access it. However, when a method is protected, all instances
# of the class have access to it. This means we can easily share sensitive
# data between instances of the same type.