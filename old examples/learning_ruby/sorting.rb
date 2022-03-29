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

	def show_sort
		puts @queue.sort_by { |key,value| value}
	end

	private
	def order_queue
		@queue = @queue.sort_by { |key, value| value }.to_h
	end
end

@pq = PriorityQueue.new

@pq.insert("edge1", 2)
@pq.insert("edge2", 10)
@pq.insert("edge3", 5)
@pq.insert("edge4", 0)

min = @pq.remove_min

puts min

@pq.show_sort
