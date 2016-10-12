class Anagram
   attr_reader :word
   
   def initialize(word)
     @word = word       
   end
   
   def match(anagrams)
      anagrams.select do |anagram|
        anagram.downcase.chars.sort.join == word.downcase.chars.sort.join \
        && anagram.downcase != word.downcase
      end
   end
end
