=begin
OO Exercises
Launch School
Kenny Chong 
10/06/2016 10:25 PM

https://launchschool.com/exercises/a04eaf49
=end

class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student
  def initialize(name, year)
    super
  end
end
