=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 8:47 PM

Complete this program so that it produces the expected output:

class Book
  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

Expected output:

The author of "Snow Crash" is Neil Stephenson.
book = "Snow Crash", by Neil Stephenson.
=end

class Book
  attr_reader :title, :author
  
  def initialize(author, title)
    @author = author
    @title = title
  end
  
  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

=begin
Further Exploration

What are the differences between attr_reader, attr_writer, and attr_accessor? 
Why did we use attr_reader instead of one of the other two? 
Would it be okay to use one of the others? Why or why not?

Instead of attr_reader, suppose you had added the following methods to this class:

def title
  @title
end

def author
  @author
end

Would this change the behavior of the class in any way? 
If so, how? If not, why not? Can you think of any advantages of this code?

Answers:
attr_reader provides only getter methods
attr_writer provides only setter methods
attr_accessor provides both getter and setter methods

If we don't need to update the states for the objects, then it is best to have
only getter methods and not expose methods that changes the object's state.

If you want both setter methods with the getter methods, then it is okay
to use attr_accessor, else then use attr_reader.

Manual adding getter methods will not affect the behavior of the class. Sometimes
it better to manually adding getter methods if you need to do some 
extra processing inside them.
=end