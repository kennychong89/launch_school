=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 10:14 PM

Assume you have the following code:

class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1

and this output:

Home 1 is cheaper
Home 2 is more expensive

Modify the House class so that the above program will work. 
You are permitted to define only one new method in House.
=end
class House
    attr_reader :price
    include Comparable
    
    def initialize(price)
      @price = price
    end
    
    def <=>(other)
      price <=> other.price
    end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1

=begin
Is the technique we employ here to make House objects comparable a good one? 
(Hint: is there a natural way to compare Houses? Is price the only criteria 
you might use?) What problems might you run into, if any? 
Can you think of any sort of classes where including Comparable is a good idea?

Answer:
I think the technique is valid. Besides the prices, we can also compare 
how many rooms each house may have or age of each house. The problem is
how do we define comparsions for each of the attributes above if we already
defined a comparable for prices?

Another benefit of using Comparable is when we need a custom sort criteria for
the data structures we use. Instead of sorting numbers, can we sort by name or
by a custom object?
=end