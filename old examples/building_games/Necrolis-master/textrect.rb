require 'gosu'

class TextRect
    attr_reader :text

    @@gfont = Gosu::Font.new(16)

    def self.default_font
        return @@gfont
    end

    def set_text(text)
        @text = text
    end

    def width
        return @font.text_width(@text)
    end

    def empty?
        return @text == nil || @text.size == 0
    end

    def height
        return @font.height
    end

    def draw(x, y, z, tcolor=Gosu::Color::WHITE, rcolor=Gosu::Color::BLACK)
        if @text != nil
            w = @font.text_width(@text)
            h = @font.height
            Gosu::draw_rect( x - w * @rx, y - h * @ry, w, h, rcolor, z) if @rect
            @font.draw_rel( @text, x, y, z+1, @rx, @ry, 1, 1, tcolor )
        end
    end

    # If rect is nil text will be displayed with no background
    def initialize(text, centered=false, rect=false, font=TextRect.default_font)
        @text = text
        @font = font
        @rect = rect

        if centered
            @rx = 0.5
            @ry = 0.5
        else
            @rx = 0
            @rx = 0
        end

    end

end


# Designed for units.
class DynamicTextRect < TextRect
    attr_reader :kind

    NONE = 0

    @@gfont = Gosu::Font.new(16)

    def self.default_font
        return @@gfont
    end

    def attach(who)
        @attached = who
    end

    def update(dt)
        @timer_dt -= dt if @timer_enabled

        if @timer_enabled && @timer_dt <= 0 then
            self.set_text(nil)
            @timer_enabled = false
        end
    end

    def set_timer(time)
        @timer_dt = time
        @timer_enabled = true
    end

    # You don't want the same message to be repeated? Filter them by kind
    # If another messages of the same kind arrives ignore it

    def set_text(text, kind=NONE)
        @text = text
        @kind = kind if kind != NONE
    end

    def width
        return @font.text_width(@text)
    end

    def height
        return @font.height
    end

    def draw(x, y, z, tcolor=Gosu::Color::WHITE, rcolor=Gosu::Color::BLACK)
        super x,y,z,tcolor,rcolor
    end

    # If rect is nil text will be displayed with no background
    def initialize(text, centered=false, rect=false, font=TextRect.default_font)
        super text, centered, rect, font

        @attached = nil
        @timer_enabled = false
        @timer_dt = 0.0
        @kind = NONE
    end

end