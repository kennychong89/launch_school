=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 9:21 PM

Consider the following class definition:

class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

There is nothing technically incorrect about this class, 
but the definition may lead to problems in the future. 
How can this class be fixed to be resistant to future problems?
=end

# Answer: We can seprate the database information into a seperate
# class or module, so that if the database change one day, it can
# changed without modifying Flight class.

# Actual Answer: Prevent database from being accessed by 
# deleting :database_handle accessor.