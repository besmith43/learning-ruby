class Player

	ROTATION_SPEED = 3
	ACCELERATION = 2
	FRICTION = 0.9

	attr_reader :x, :y, :angle, :radius

	def initialize(window)
		@x = 500
		@y = 750
		@image = Gosu::Image.new('images/ship.png')
		@velocity_x = 0
		@velocity_y = 0
		@angle = 0
		@radius = 20
		@window = window
	end

	def draw
		@image.draw_rot(@x, @y, 1, @angle)
	end

	def move_right
		@x += ACCELERATION
	end

	def move_left
		@x -= ACCELERATION
	end

	def turn_right
		@angle += ROTATION_SPEED
	end

	def turn_left
		@angle -= ROTATION_SPEED
	end

	def accelerate
		@velocity_x += Gosu.offset_x(@angle, ACCELERATION)
		@velocity_y += Gosu.offset_y(@angle, ACCELERATION)
	end

	def move
		@x += @velocity_x
		@y += @velocity_x
		@velocity_x *= FRICTION
		@velocity_y *= FRICTION
		if @x > @window.width - @radius
			@vx = 0
			@x = @window.width - @radius
		end
		if @x < @radius
			@vx = 0
			@x = @radius
		end
		if @y > @window.height - @radius
			@vy = 0
			@y = @window.height - @radius
		end
	end
end
