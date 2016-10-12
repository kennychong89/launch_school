=begin
OO Exercises
Launch School
Kenny Chong 
10/05/2016 4:54 PM

https://launchschool.com/exercises/be610ed0
=end
module Walkable
  def walk
    "#{self} #{gait} forward"
  end
end

class Noble
  include Walkable
  attr_reader :name, :title
  
  def initialize(name, title)
    @name = name
    @title = title
  end
  
  def to_s
    "#{title} #{name}"
  end
  
  private
  
  def gait
    "strut"  
  end
end

byron = Noble.new("Byron", "Lord")
p byron.walk