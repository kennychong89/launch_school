=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 10:33 PM

What will the following code print?

class Something
  def initialize
    @data = 'Hello'
  end
  
  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata
puts thing.dupdata
=end

class Something
  def initialize
    @data = 'Hello'
  end
  
  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata # Prints 'ByeBye'
puts thing.dupdata     # Prints 'HelloHello'