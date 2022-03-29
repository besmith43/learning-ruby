require 'gosu'

class Shape
    
    def draw(color, fillcolor, z)
    end
    
    def contains?(x, y)
        return false
    end
    
    def intersects?(other)
        return false
    end
    
end


class Rectangle < Shape
    attr_accessor :x, :y, :w, :h
    

    def intersects?(other)
        return ( @x <= other.x+other.w && other.x <= @x+@w && @y <= other.y+other.h && other.y <= @y+@h )
    end

    def initialize(x,y,w,h,centered=false,bordersize=1)
        #@x=x
        #@y=y
        @w=w
        @h=h
        @bs = bordersize
        @centered = centered
        self.set_pos(x,y,centered)
    end
    
    def get_center
        return [@x+@w/2, @y+@h/2]
    end
    
    def set_pos(x, y, centered=@centered)
        if centered
            @x = x - @w/2
            @y = y - @h/2
        else
            @x=x
            @y=y
        end
    end
    
    def move(x, y)
        @x += x
        @y += y
    end
    
    def contains?(x,y)
        return (x >= @x and y >= @y and x <= @x+@w and y <= @y+@h)
    end
    
    def draw(color, fillcolor, z)
        Gosu::draw_rect( @x, @y, @w, @h, fillcolor, z )

        Gosu::draw_rect( @x, @y, @w, @bs, color, z )
        Gosu::draw_rect( @x, @y, @bs, @h, color, z )
        Gosu::draw_rect( @x, @y+@h, @w+@bs, @bs, color, z )
        Gosu::draw_rect( @x+@w, @y, @bs, @h, color, z )
    end
    
end

