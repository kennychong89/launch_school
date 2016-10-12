class Atbash
  attr_reader :code
  ALPHABET = ('a'..'z').to_a

  def self.encode(code)
    substitute = proc do |char|
      char =~ /[a-zA-Z]/ ? ALPHABET['z'.ord - char.ord] : char
    end

    filter = proc { |char| char =~ /[a-zA-Z0-9]/ }

    code.downcase.chars.select(&filter)
        .map(&substitute)
        .each_slice(5)
        .inject('') do |encoded, word|
          encoded.concat(word.join).concat(' ')
        end.strip
  end
end
