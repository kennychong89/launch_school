require 'pry'
ALPHABET = ['A','B','C','D','E','F','G',
            'H','I','J','K','L','M','N',
            'O','P','Q','R','S','T','U',
            'V','W','X','Y','Z']

def rot13_decrypt(name)
  name.split('').map do |letter|
    if !letter.match(/^[[:alpha:]]$/)
        letter
    else
       x = letter.downcase.ord - 13
       l = x < "a".ord ? (letter.downcase.ord + 13).chr : x.chr
       letter == letter.upcase ? l.upcase : l 
    end
  end.join
end

names = File.readlines('names.txt').map(&:chomp)
names.each { |name| puts "#{name}: #{rot13_decrypt(name)}" }

