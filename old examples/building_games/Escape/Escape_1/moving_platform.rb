#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
class MovingPlatform
  FRICTION = 0.7
  ELASTICITY = 0.8
  SPEED_LIMIT = 40
  attr_reader :body,:width,:height
  def initialize(window, x, y, range, direction)
    space = window.space
    @window = window
    @x_center = x
    @y_center = y
    @direction = direction
    @range = range
    @body = CP::Body.new(50000, 100.0 / 0)
    @width = 96
    @height = 16
    @body.v_limit = SPEED_LIMIT
    if @direction == :horizontal
      @body.p = CP::Vec2.new(x + range + 100, y)
      @move = :right
    else
      @body.p = CP::Vec2.new(x, y + range + 100)
      @move = :down
    end
    bounds = [CP::Vec2.new(-48, -8), 
               CP::Vec2.new(-48, 8), 
               CP::Vec2.new(48, 8), 
               CP::Vec2.new(48, -8)]
    shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0, 0))
    shape.u = FRICTION
    shape.e = ELASTICITY
    space.add_body(@body)
    space.add_shape(shape)
    @image = Gosu::Image.new('images/platform.png')
    @body.apply_force(CP::Vec2.new(0, -20000000), CP::Vec2.new(0, 0))
  end
  def draw
    @image.draw_rot(@body.p.x, @body.p.y , 0, 1)
  end
  def move
    case @direction
    when :horizontal
      if @body.p.x > @x_center + @range && @move == :right
        @body.reset_forces
        @body.apply_force(CP::Vec2.new(0, -20000000), CP::Vec2.new(0, 0))
        @body.apply_force(CP::Vec2.new(-20000000, 0), CP::Vec2.new(0, 0))
        @move = :left
      elsif @body.p.x < @x_center - @range && @move == :left
        @body.reset_forces
        @body.apply_force(CP::Vec2.new(0, -20000000), CP::Vec2.new(0, 0))
        @body.apply_force(CP::Vec2.new(20000000, 0), CP::Vec2.new(0, 0))
        @move = :right
      end
      @body.p.y = @y_center
    when :vertical
      if @body.p.y > @y_center + @range && @move == :down
        @body.reset_forces
        @body.apply_force(CP::Vec2.new(0, -25000000), CP::Vec2.new(0, 0))
        @move = :up
      elsif @body.p.y < @y_center - @range && @move == :up
        @body.reset_forces
        @body.apply_force(CP::Vec2.new(0, -15000000), CP::Vec2.new(0, 0))
        @move = :down
      end
      @body.p.x = @x_center
    end
  end
end
