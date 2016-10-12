=begin
OO Exercises
Launch School
Kenny Chong 
10/03/2016 9:49 PM

Using the following code, multiple @age by 2 upon assignment, then
multiple @age by 2 again when @age is returned by the getter method.
=end

class Person
  def age=(age)
    @age = age * 2
  end
  
  def age
    @age * 2
  end
end

person1 = Person.new
person1.age = 20
puts person1.age