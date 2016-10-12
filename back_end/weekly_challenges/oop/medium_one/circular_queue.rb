=begin
OO Exercises
Launch School
Kenny Chong 
10/06/2016 10:25 PM

https://launchschool.com/exercises/1fcae291
=end

class CircularQueue
  attr_reader :size
  
  def initialize(size)
    @circular_queue = Array.new(size)
    @size = size
    @oldest_location = 0
    @current_location = 0
  end
  
  def enqueue(item)
    dequeued_item = nil
    dequeued_item = dequeue if full?
 
    @circular_queue[current_location] = item
    next_current_location
    
    dequeued_item
  end
  
  def dequeue
    dequeued_item = @circular_queue[oldest_location]
    if !dequeued_item.nil?
      @circular_queue[oldest_location] = nil
      next_oldest_location
    end
    dequeued_item
  end
  
  def full?
    @circular_queue.count(nil) == 0   
  end
  
  private
  attr_reader :current_location, :oldest_location
  
  def next_oldest_location
    @oldest_location = (oldest_location + 1) % size
  end
  
  def next_current_location
    @current_location = (current_location + 1) % size
  end
end

queue = CircularQueue.new(3)
queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
