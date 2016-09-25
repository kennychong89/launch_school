def compute(ele)
  block_given? ? yield(ele) : "Does not compute."
end

puts compute(5) { |ele| ele + 3 } == 8
puts compute('a') {|ele| ele + 'b' } == 'ab'
puts compute(0) == 'Does not compute.'