=begin
  Create a module named Transportation that contains three classes:
  Vehicle, Truck, and Car. Truck and Car should both inherit from Vehicle.
=end

module Transportation
   class Vehicle
   end
   
   class Truck < Vehicle
   end 
   
   class Car < Vehicle
     def drive
        "room! room!" 
     end
   end
end

c = Transportation::Car.new
p c.drive