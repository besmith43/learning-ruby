require_relative 'shape'

class Entity
    attr_reader :x, :y, :z, :angle

    def update(dt)
    end

    def draw
    end

    def rotate(ang)
        self.set_angle( @angle+ang )
    end

    def set_angle(ang)
        @angle = ang

        @angle = @angle%360
    end

    def move_pos(x,y)
        @x += x
        @y += y
    end

    def set_pos(x,y)
        #@x = x
        #@y = y
        self.move_pos(x-@x,y-@y)
    end

    def get_pos(x,y)
        return [@x, @y]
    end

    def look_towards(x,y)
        @angle = Gosu::angle(@x, @y, x, y)  #Math.atan2( y-@y, x-@x )
    end

    # Returns true if target reached
    def move_towards(x,y,speed)
        dx = x-@x
        dy = y-@y

        norm = Math.sqrt( dx*dx+dy*dy )

        if norm < speed || norm < 1
            self.set_pos(x,y)
            return true
        end

        #self.look_towards(x, y)
        self.move_pos(dx*(speed/norm),dy*(speed/norm))

        return false
    end

    def initialize(x,y,z)
        @x=x
        @y=y
        @z=z
        @angle = 0.0
    end

end



class CollisionEntity < Entity
    attr_reader :rect
    
    def show_rectangle(wha=true)
        @show_rect = wha
    end

    def contains?(x,y)
        return @rect.contains?(x,y)
    end

    def collides_with?(who)
        return @rect.intersects?(who.rect)
    end

    def collides_group?(grp)
        res = []

        grp.each do |grunit|
            res.push(grunit) if self.collides_with?(grunit) && grunit != self
        end

        return res
    end

    def move_pos(x,y)
        super
        @rect.set_pos(@x.round, @y.round)
    end

    def contains?(x,y)
        return @rect.contains?(x,y)
    end

    def draw(color=Gosu::Color::WHITE, innercolor=Gosu::Color::NONE)
        @rect.draw(color, innercolor, @z-1 ) if @show_rect
    end

    def initialize(x,y,z,rwid,rhei)
        super x, y, z

        @show_rect = false
        @rect = Rectangle.new(x,y,rwid,rhei,true)
    end

end
