require 'set'
class SumOfMultiples
   attr_reader :numbers
   
   def initialize(*numbers)
     @numbers = Set.new(numbers)      
   end
   
   def self.to(limit, numbers = [0,3,5])
     multiples = Set.new  
     numbers.each do |num|
        multiples.merge(multiples_of(num, limit))    
     end
     multiples.inject(:+)
   end
   
   def to(limit)
     self.class.to(limit, @numbers)
   end

   def self.multiples_of(num, limit)
     multiples = []
     (1..limit).each do |i|
        break if (num * i) >= limit
        multiples.push(num * i)
     end
     multiples
   end
end
