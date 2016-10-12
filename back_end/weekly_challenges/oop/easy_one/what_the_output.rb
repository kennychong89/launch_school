=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 8:20 PM

Take a look at the following code:

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    @name.upcase!
    "My name is #{@name}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

What output does this code print? 
Fix this class so that there are no surprises waiting 
in store for the unsuspecting developer.
=end

class Pet
  attr_reader :name
  
  def initialize(name)
    @name = name.to_s
  end
  
  def to_s
    @name.upcase!
    "My name is #{@name}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

=begin
Fluffy
My name is FLUFFY.
FLUFFY
FLUFFY

To fix:
class Pet
  attr_reader :name
  
  def initialize(name)
    @name = name.to_s
  end
  
  def to_s
    "My name is #{@name.upcase}."
  end
end

Further Exploration 

What would happen in this case?
name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name


=end


