class Sieve
   attr_reader :limit
   
   def initialize(limit)
      raise ArgumentError.new('limit must be greater than 1') if limit < 2 
      @limit = limit
      @numbers = Hash.new
      (2..limit).each { |i| @numbers[i] = false }
   end
   
   def primes
      curr_num = 2
      
      loop do
        mark_composites(curr_num)
        curr_num = find_next_unmarked(curr_num + 1)
        break unless !curr_num.nil? && curr_num <= limit
      end
      
      @numbers.delete_if { |key,value| value }.keys() 
   end
   
   private
   
   def mark_composites(num)
      multipler = 2
      (limit-num).times do
        @numbers[num * multipler] = true
        multipler += 1
      end
   end
   
   def find_next_unmarked(curr_num)
       (curr_num).upto(limit) do |i|
          return i unless @numbers[i]       
       end
       nil
   end
end
