class PriorityQueue
  def initialize
    @queue = {}
  end

  def any?
    @queue.any?
  end

  def insert(key, value)
    @queue[key] = value
    order_queue
  end

  def remove_min
    @queue.shift.first
  end

  private
  def order_queue
	  #@queue = @queue.sort_by {|_key, value| value }.to_h
	  @queue.sort_by {|_key, value| value }
  end
end
