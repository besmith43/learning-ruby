#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
class Camera
  attr_reader :x_offset,:y_offset

  def initialize(window, space_height, space_width)
    @window = window
    @space_height = space_height
    @window_height = window.height
    @space_width = space_width
    @window_width = window.width
    @x_offset_max = space_width - @window_width
    @y_offset_max = space_height - @window_height
  end
  def view
    @window.translate(-@x_offset, -@y_offset) do 
      yield
    end
  end
  def center_on(sprite, right_margin, bottom_margin)
    @x_offset = sprite.x - @window_width + right_margin
    @y_offset = sprite.y - @window_height + bottom_margin
    @x_offset = @x_offset_max if @x_offset > @x_offset_max
    @x_offset = 0 if @x_offset < 0
    @y_offset = @y_offset_max if @y_offset > @y_offset_max
    @y_offset = 0 if @y_offset < 0
  end
  def shake
    @x_offset += rand(9) - 4
    @y_offset += rand(9) - 4
  end
end
