=begin
OO Exercises
Launch School
Kenny Chong 
10/05/2016 4:45 PM

What is wrong with the following code? What fix(es) would you make?

class Expander
  def initialize(string)
    @string = string
  end

  def to_s
    self.expand(3)
  end

  private

  def expand(n)
    @string * n
  end
end

expander = Expander.new('xyz')
puts expander
=end

class Expander
  def initialize(string)
    @string = string
  end

  def to_s
    expand(3) # remove self
  end

  private

  def expand(n)
    @string * n
  end
end

expander = Expander.new('xyz')
puts expander

=begin
Answer: Since exapnd is a private method, we need to remove the self from 
expand() inside the to_s method. Private methods cannot be called with an
explicit reciever.
=end