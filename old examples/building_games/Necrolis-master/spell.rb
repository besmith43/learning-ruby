require_relative 'scenemaster'


class Spell

    def cast(x,y,player)
    end

    def on_cast(x, y, player)
        if self.can_cast?(x,y,player)
            player.energy -= self.energy
            self.cast(x,y,player) 
        end
    end

    def energy
        return 0
    end

    def sound
        return nil
    end

    def name
        return "SPELL"
    end

    def graphic
        return 0
    end

    def can_cast?(x,y,player)
        multip = @world.summonable_pos?(x, y) ? 0.75 : 1
        return player.energy >= (multip*self.energy)+SceneMaster.get.current.ENERGY_SUMMON_BASE
    end

    def initialize(world)
        @world = world
    end

end

class FingerOfDeath < Spell

    def energy
        return 25
    end

    def graphic
        return 0
    end

    def name
        "Finger of Death"
    end

    def can_cast?(x,y,player)
        ret = super(x,y,player)
        selectunit = @world.any_unit_xy(x,y)

        @target = selectunit

        return ret && selectunit != nil && selectunit.player.is_enemy?(player) && @target.stats.health <= 8
    end

    def cast(x,y,player)
        @target.die(player)
    end

end