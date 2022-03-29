class Wall
	def initialize
		@x = x
		@y = y
		@image = Gosu::Image.new('images/wall.png')
	end

	def draw
		image.draw(@x, @y, 1)
	end
end
