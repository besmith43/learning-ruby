#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
class Wall
  FRICTION = 0.7
  ELASTICITY = 0.2
  def initialize(window, x, y, width, height)
    space = window.space
    @x = x
    @y = y
    @width = width
    @height = height
    @body = CP::Body.new_static()
    @body.p = CP::Vec2.new(x,y)
    @bounds = [CP::Vec2.new(-width / 2, -height / 2),
               CP::Vec2.new(-width / 2, height / 2),
               CP::Vec2.new(width / 2, height / 2),
               CP::Vec2.new(width / 2, -height / 2)]
    @shape = CP::Shape::Poly.new(@body, @bounds, CP::Vec2.new(0, 0))
    @shape.u = FRICTION
    @shape.e = ELASTICITY
    space.add_shape(@shape)
  end
end