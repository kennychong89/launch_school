class Octal
   attr_reader :octal
   
   def initialize(octal)
      @octal = octal
   end
   
   def to_decimal
       return 0 if octal.match(/[a-zA-Z89]/)
       exponent = octal.size - 1
       decimal = 0
       octal.each_char do |digit|
         decimal += (digit.to_i) * (8**exponent)
         exponent -= 1
       end
       decimal
   end
end
