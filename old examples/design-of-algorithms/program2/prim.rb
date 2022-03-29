require_relative "priority_queue"

class Prim
	
	def initialize(graph)
		@graph = graph
		@mst = []
		@pq = PriorityQueue.new
		@checked = []
	end

	def compute_prim
		current_node = @graph.nodes[0]

		loop do
			current_node.adjacent_edges.each do |adj_edge|
				if !@checked.include?(adj_edge.to)
					@pq.insert(adj_edge, adj_edge.weight)	
				end
			end

			@checked << current_node
			min_edge = @pq.remove_min

			if !@checked.include?(min_edge.to)
				current_node = min_edge.to
				@mst << min_edge
			end
				
			break if !@pq.any?
		end
		
		@mst
	end
end
