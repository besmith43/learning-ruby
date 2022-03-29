class Enemy
	SPEED = 4
	attr_reader :x, :y, :radius
	def initialize(window, x, y)
		@x = x
		@y = y
		@image = Gosu::Image.new('images/enemy.png')
	end
	def draw
		@image.draw(@x, @y, 1)
	end
	def move(x, y)
		if x == 1
			@x += SPEED*x
		end
		if y == 1
			@y += SPEED*y
		end
	end
end
