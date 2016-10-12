=begin
OO Exercises
Launch School
Kenny Chong 
10/06/2016 9:43 PM

https://launchschool.com/exercises/d0f9783f
=end

class Machine
  def start
    flip_switch(:on)      
  end
  
  def stop
    flip_switch(:off)
  end

  def state
    switch.to_s
  end
  
  private
    
  attr_accessor :switch
  
  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

machine = Machine.new
machine.start
p machine.state