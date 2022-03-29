require_relative 'draworder'

class EffectType
    attr_reader :id, :anims, :animtime
    DEFAULT_ANIM_TIME = 0.2

    def initialize(id, anims, animtime=DEFAULT_ANIM_TIME)
        @anims = anims
        @animtime = animtime
        @id = id
    end

end


class EffectMaster
    DISINTEGRATE = 0
    @@inst = nil

    def self.get
        @@inst ||= EffectMaster.new

        return @@inst
    end

    def bring(id)
        return @effects[id]
    end

    def add(who)
        @effects[who.id] = who
    end

    def setup
        self.add( EffectType.new(DISINTEGRATE, 3) )
    end

    def initialize
        @effects = {}
    end

end


class Effect

    def attach(who)
        @attached = who
    end

    def draw
        @home.effect_texture[@kind.id+@anim].draw_rot(@x, @y, @z, 0, 0.5, 0.5, @home.zoom_x, @home.zoom_y)
    end

    def update(dt)
        @time -= dt

        if @time <= 0
            @anim += 1
            @time = @kind.animtime

            if @anim >= @kind.anims
                @dead = true
            end
        else
            if @attached != nil
                @x = @attached.x
                @y = @attached.y
            end
        end
    end

    def is_dead?
        @dead
    end

    def initialize(x,y,id,home)
        @kind = EffectMaster.get.bring(id)
        @home = home
        @time = @kind.animtime
        @anim = 0

        @attached = nil
        @x = x
        @y = y
        @z = ZOrder::EFFECTS
        @dead = false
    end

end

