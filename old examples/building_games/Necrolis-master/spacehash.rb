require 'set'

require_relative 'shape'
require_relative 'draworder'

class SpaceHash
    attr_reader :tile_x, :tile_y
    CELL_SIZE = 80

    def draw
        (@borders.w+1).times do |x|
            Gosu::draw_line(x*@tile_x, 0, Gosu::Color::WHITE, x*@tile_x, @borders.h*@tile_y, Gosu::Color::WHITE, ZOrder::DEBUG)
        end

        (@borders.h+1).times do |y|
            Gosu::draw_line(0, y*@tile_y, Gosu::Color::WHITE, @borders.w*@tile_x, y*@tile_y, Gosu::Color::WHITE, ZOrder::DEBUG)
        end

        @borders.w.times do |x|
            @borders.h.times do |y|
                @debug_font.draw( "#{@matrix[x][y].size}", x*(@tile_x+0.5), y*@tile_y, ZOrder::DEBUG )
            end
        end
    end

    def rem_grid(x,y,who)
        @matrix[x][y].delete?(who)
    end

    def rem_pos(x,y,who)
        self.rem_grid( (x/@tile_x).to_i, (y/@tile_y).to_i )
    end

    def add_grid(x, y, who)
        @matrix[x][y].add(who) if @borders.contains?(x, y)
    end

    def add_pos(x, y, who)
        self.add_grid( (x/@tile_x).to_i, (y/@tile_y).to_i )
    end

    def get_grid(x,y)
        return ( @borders.contains?(x,y)? @matrix[x][y] : @empty_set )
    end

    def get_pos(x,y)
        return self.get_grid( (x/@tile_x).to_i, (y/@tile_y).to_i )
    end

    def initialize(bounding_rect, tsx, tsy)
        @bounds = bounding_rect
        @borders = Rectangle.new( @bounds.x/tsx, @bounds.y/tsy, @bounds.w/tsx, @bounds.h/tsy )

        @tile_x = tsx
        @tile_y = tsy
        @empty_set = Set.new()

        @matrix = Array.new( @bounds.w ) { Array.new(@bounds.h){ Set.new() } }

        @debug_font = Gosu::Font.new(16)
    end

end
