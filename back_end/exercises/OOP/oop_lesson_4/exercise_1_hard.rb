# Launch School 
# Lesson 4: OO Exercises Hard 1
# Kenny Chong
# 08/22/2016 4:22 PM

# 1. Alyssa has been assigned a task of modifying a class
# that was initially created to keep track of secret information.
# The new requirement calls for adding logging, when clients
# of the class attempt to access the secret data. Here is the class 
# in its current form:

class SecretFile
    attr_reader :data
    
    def initialize(secret_data)
       @data = secret_data 
    end
end

# She needs to modify it so that any access to data must 
# result in a log entry being generated. That is, any call to the
# class which will result in data being returned must first call a logging
# class. The logging class has been supplied to Alyssa and looks like the
# following:
class SecurityLogger
   def create_log_entry
       
   end
end

# Hint: Assume that you can modify the initialize method in SecretFile to
# have an instance of SecurityLogger be passed in as an additional argument.

# Answer:
class SecretFile
    def initialize(secret_data, security_logger)
       @data = secret_data
       @security_logger = security_logger
    end
    
    def data
      @security_logger.create_log_entry
      @data
    end
end

# 2. Ben and Alyssa are working on a vehicle management system.
# So far, they have created classes called Auto and Motorcycle to
# represent automobiles and motorcycles. After having noticed common
# information and calculations they were performing for each type of
# vehicle, they decided to break out the commonality into a seperate class
# called WheeledVehicle. This is what their code looks like so far:

class WheeledVehicle
  attr_accessor :speed, :heading

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

# Now ALan has asked them to incorporate a new type
# of vehicle into their system - a Catamaran defined
# as follows:

class Catamaran
   attr_accessor :propeller_count, :hull_count, :speed, :heading
   
   def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    # ... code omitted ...
   end
end

# The new class does not fit well with the object hierarchy so far. 
# Catamaran don't have tires. But we still want common code to track
# fuel efficieny and range. Modify the class definitions and move code
# into a Module, as needed, to share code among the Catamaran
# and wheeled vehicles.

# Answer 1:
class Vehicle
  attr_accessor :speed, :heading

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle < Vehicle
  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    super(km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
  end
  
  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class Catamaran < Vehicle
   attr_accessor :propeller_count, :hull_count, :speed, :heading
   
   def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    super(km_traveled_per_liter, liters_of_fuel_capacity)
    # ...rest of code omitted ...
   end
end

# Answer 2:
module Tire
  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end 

class Vehicle
  attr_accessor :speed, :heading

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class Auto < Vehicle
  include Tire
  
  def initialize
    # 4 tires are various tire pressures
    super(50, 25.0)
    @tires = [30,30,32,32] 
  end
end

class Motorcycle < Vehicle
  include Tire
  def initialize
    # 2 tires are various tire pressures
    super(80, 8.0)
    @tires = [20,20]
  end
end

class Catamaran < Vehicle
   attr_accessor :propeller_count, :hull_count, :speed, :heading
   
   def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    super(km_traveled_per_liter, liters_of_fuel_capacity)
    # ...rest of code omitted ...
   end
end

# 3. Building on the prior vehicles question, we now must also track a
# a basic motorboat. A motorboat has a single propeller and hull, but
# otherwise behaves similar to a catamaran. Therefore, creators
# of Motorboat instance don't need to specify number of hulls or propellers.
# How would you modify the vehicles code to incorporate a new Motorboat class?

# Assuming we use the solution provided.
module Moveable
  attr_accessor :speed, :heading
  attr_writer :fuel_capacity, :fuel_efficiency

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

# I would create a common Boat class.
class Boat 
    attr_accessor :propeller_count, :hull_count
    
    def initialize(num_propellers, num_hulls)
        # ... other code to track Boat data omitted ...
    end

end

# Catamaran would inherit from Boat
class Catamaran < Boat
  include Moveable

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    super(num_propellers, num_hulls)
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity

    # ... other code to track catamaran-specific data omitted ...
  end
end

# So does Motorboat, except num_propellers and num_hulls are predefined
class Motorboat < Boat
  include Moveable
  
  def initialize
    super(1,1)
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end 
end

# A problem with this approach is whether or not Boat is Moveable. If it is
# I can put Moveable at the top of the Boat class.

# Include the Moveable to Boat: 
class Boat 
    include Moveable
    
    attr_accessor :propeller_count, :hull_count
    
    def initialize(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)
        self.fuel_efficiency = km_traveled_per_liter
        self.fuel_capacity = liters_of_fuel_capacity
        # ... other code to track Boat data omitted ...
    end
end

class Catamaran < Boat
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)
    super(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)

    # ... other code to track catamaran-specific data omitted ...
  end
end

class Motorboat < Boat
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)
    super(1, 1, km_traveled_per_liter, fuel_capacity)
    # also can use super without passing arguments. it take all the arguments in
    # initialize.
  end 
end

# 4. The designers of the vehicle management system now want to make an
# adjustment for how the range of vehicles is calculated. For seaborner vehicles,
# due to prevailing ocean currents, they want to add an additional 10km of range
# even if the vehicle is out of fuel.

# Alter the code related to vehicles that the range for autos and motocycles
# is still calculated as before, but for catamarans and motorboats, the range method
# will return an additional 10 km.

# Answer
module Moveable
  attr_accessor :speed, :heading
  attr_writer :fuel_capacity, :fuel_efficiency

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Boat 
    include Moveable
    
    attr_accessor :propeller_count, :hull_count
    
    def initialize(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)
        self.fuel_efficiency = km_traveled_per_liter
        self.fuel_capacity = liters_of_fuel_capacity
        # ... other code to track Boat data omitted ...
    end
    
        
    # Override the range method in Moveable
    def range
      (self.fuel_capacity * self.fuel_efficiency) + 10
      
      # Alternate
      #     range_by_using_fuel = super
      #     return range_by_using_fuel + 10
    end
end

class Catamaran < Boat
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)
    super(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)

    # ... other code to track catamaran-specific data omitted ...
  end
end

class Motorboat < Boat
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, fuel_capacity)
    super(1, 1, km_traveled_per_liter, fuel_capacity)
    # also can use super without passing arguments. it take all the arguments in
    # initialize.
  end 
end
