#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
require 'gosu'

class WhackARuby < Gosu::Window
  def initialize
    super 800,600,false
    self.caption = "Whack the Ruby!"
    @image = Gosu::Image.new(self,'ruby.png',false)
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @vx = 5
    @vy = 5
    @visible = 0
    @hammer_image = Gosu::Image.new(self,'hammer.png', false)
    @hit = 0    
  end
  def update
    @x += @vx
    @y += @vy

    if @x + @width/2 > 800 or @x - @width/2 < 0
      @vx *= -1
    end
    if @y + @height/2 > 600 or @y - @height/2 < 0
      @vy *= -1
    end
    @visible -= 1
    if @visible < -10 and rand < 0.01
      @visible = 15
    end
    
    
  end
  def button_down(id)
    if (id == Gosu::MsLeft) and @visible
      if Gosu.distance(mouse_x,mouse_y,@x,@y)<50
        @hit = 1
      else
        @hit = -1
      end
    end
  end
  def draw
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    draw_quad(0,0,c,800,0,c,800,600,c,0,600,c)
    @hit = 0
    @image.draw(@x-@width/2, @y-@height/2,1) if @visible > 0
    @hammer_image.draw(mouse_x-40, mouse_y-10, 1)
  end

end

window = WhackARuby.new
window.show