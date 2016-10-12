class Trinary
  attr_reader :trinary
  
  def initialize(trinary)
    @trinary = trinary
  end
  
  def to_decimal
    return 0 if trinary.match(/[^0-2]/)
    exponent = trinary.size - 1
    decimal = 0
    trinary.each_char do |c|
        decimal += c.to_i * (3**exponent)
        exponent -= 1
    end
    decimal
  end
end
