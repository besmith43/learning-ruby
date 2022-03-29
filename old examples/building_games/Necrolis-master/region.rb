class Region
    attr_reader :x, :y, :w, :h, :name

    def initialize(name, x,y,w,h,data)
        @x,@y,@w,@h=x,y,w,h
        @data = data != nil ? data : {}
        @name = name


    end

    def name
        return @name
    end

    def get_prop(name, default=nil)
        return @data.fetch(name, default)
    end

    def set_prop(name, val)
        @data[name] = val
    end

    def draw(z)
    end

    def contains?(x,y)
        return (x>=@x && y>=@y && x<=@x+@w && y<=@y+@h)
    end

    def centerx
        (@x+@w/2).to_i
    end

    def centery
        (@y+@h/2).to_i
    end

    def center
        return [ (@x+@w/2).to_i, (@y+@h/2).to_i ]
    end

    def update(dt)
    end

end