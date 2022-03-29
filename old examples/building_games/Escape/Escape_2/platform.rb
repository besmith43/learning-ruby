#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
class Platform
  attr_reader :body, :width, :height
  def initialize(window, x, y)
  	space = window.space
    @width = 96
    @height = 16
  	@body = CP::Body.new_static
  	@body.p = CP::Vec2.new(x,y)
  	bounds = [CP::Vec2.new(-48, -8),
               CP::Vec2.new(-48, 8),
               CP::Vec2.new(48, 8),
               CP::Vec2.new(48, -8)]
  	shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0, 0))
    shape.u = 0.7
    shape.e = 0.8
    space.add_shape(shape)
    @image = Gosu::Image.new('images/platform.png')
  end
  def draw
  	@image.draw_rot(@body.p.x, @body.p.y, 1, 0)
  end
end
