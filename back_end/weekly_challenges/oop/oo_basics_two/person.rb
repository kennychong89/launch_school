=begin
Public Secret 
Create a class named Person with an instance variable named @secret.
Use a setter method to add a value to @secret, then use a getter
method to print @secret.

Private Secret
Using the following code, add a method named 
share_secret that prints value of @secret when invoked.

class Person
  attr_writer :secret

  private

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret

Protected Secret
Using the following code, add an instance method name compare_secret that
compares the value of @secret from person1 with the value of @secret from
person2.

class Person
  attr_writer :secret

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

person1.compare_secret(person2)
=end

class Person
  attr_writer :secret
  
  def share_secret
    puts secret
  end
  
  def compare_secret(person1)
    puts secret == person1.secret   
  end 
  
  protected
  
  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

person1.compare_secret(person2)

