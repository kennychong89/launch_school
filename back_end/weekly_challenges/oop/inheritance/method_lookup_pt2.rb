=begin
Using the following code, determine the lookup path 
used when invoking cat1.color. Only list the classes 
that were checked by Ruby when searching for the #color method.

class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new('Black')
cat1.color
=end

class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new('Black')
cat1.color

# Lookup Path (start->end):
# Cat class
# Animal class
# Object class
# Kernal class
# BasicObject class