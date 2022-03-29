class Graph < Array
	attr_reader :edges

	def initialize
		@edges = []
	end

	def connect(src, dst, length = 1)
		unless self.include?(src)
			raise ArgumentException, " No such vertex: #{src}"
		end
		unless self.include?(dst)
			raise ArgumentException, "No such vertex: #{dst}"
		end
		@edges.push Edge.new(src, dst, length)
	end

	def connect_mutually(vertex1, vertex2, length = 1)
		self.connect vertex1, vertex2, length
		self.connect vertex2, vertex1, length
	end

	def neighbors(vertex)
		neighbors = []
		@edges.each do |edge|
			neighbors.push edge.dst if edge.src == vertex
		end
		return neighbors.uniq
	end

	def length_between(src, dst)
		@edges.each do |edge|
			return edge.length if edge.src == src and edge.dst == dst
		end
		nil
	end

	def dijkstra(src, dst = nil)
		distances = {}
		previouses = {}

		self.each do |vertex|
			distances[vertex] = nil # Infinity
			previouses[vertex] = nil
		end

		distances[src] = 0
		vertices = self.clone
		until vertices.empty?
			nearest_vertex = vertices.inject do |a, b|
				next b unless distances[a]
				next a unless distances[b]
				next a if distances[a] < distances[b]
				b
			end
			break unless distances[nearest_vertex]
			if dst and nearest_vertex == dst
				return distances[dst]
			end

			neighbors = vertices.neighbors(nearest_vertex)
			neighbors.each do |vertex|
				alt = distances[nearest_vertex] + vertices.length_between(nearest_vertex, vertex)
				if distances[vertex].nil? or alt < distances[vertex]
					distances[vertex] = alt
					previouses[vertices] = nearest_vertex
				end
			end

			vertices.delete nearest_vertex
		end

		if dst
			return nil
		else
			return distances
		end
	end
end

