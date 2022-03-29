class Edge
	attr_accessor :src, :dst, :length

	def initialize(src, dst, length = 1)
		@src = src
		@dst = dst
		@length = length
	end
end
