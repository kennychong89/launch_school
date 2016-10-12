=begin
OO Exercises
Launch School
Kenny Chong 
10/04/2016 10:04 PM

Correct the following program so it will work properly. 
Assume that the Customer and Employee classes have complete implementations; 
just make the smallest possible change to ensure that objects of both 
types have access to the print_address method.

module Mailable
  def print_address
    puts "#{name}"
    puts "#{address}"
    puts "#{city}, #{state} #{zipcode}"
  end
end

class Customer
  attr_reader :name, :address, :city, :state, :zipcode
end

class Employee
  attr_reader :name, :address, :city, :state, :zipcode
end

betty = Customer.new 
bob = Employee.new
betty.print_address
bob.print_address
=end

module Mailable
  def print_address
    puts "#{name}"
    puts "#{address}"
    puts "#{city}, #{state} #{zipcode}"
  end
end

class Customer
  attr_reader :name, :address, :city, :state, :zipcode
  include Mailable
end

class Employee
  attr_reader :name, :address, :city, :state, :zipcode
  include Mailable
end

betty = Customer.new
bob = Employee.new
betty.print_address
bob.print_address