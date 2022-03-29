require 'gosu'

class Player
    attr_reader :color, :pid
    attr_accessor :energy, :corpses

    NEUTRAL=0
    ALLY=1
    ENEMY=2

    def id
        return @pid
    end

    def set_state(play, how=NEUTRAL, twoway=true)
        @states[play] = how
        play.set_state(self, how, false) if twoway
    end

    def get_state(play)
        return @states.fetch(play, NEUTRAL)
    end

    def is_enemy?(play)
        return self.get_state(play) == ENEMY
    end

    def clear
        @states = {}
    end

    def initialize(id, color)
        @states = {}
        @pid = id
        @color = color

        @energy = 0
        @corpses = 0
    end

end


class PlayerMaster
    P1 = 1
    P2 = 2

    @@PLAYER_1 = nil
    @@PLAYER_2 = nil

    def self.PLAYER_1
        return @@PLAYER_1
    end

    def self.PLAYER_2
        return @@PLAYER_2
    end


    def initialize
        @players = {}
    end

    def setup
        p1 = Player.new( P1, Gosu::Color::WHITE )
        p2 = Player.new( P2, Gosu::Color::RED )

        @@PLAYER_1 = p1
        @@PLAYER_2 = p2

        p1.set_state(p2, Player::ENEMY)

        self.add( p1 )
        self.add( p2 )
    end

    def add(who)
        @players[who.id] = who
    end

    def bring(id)
        return @players[id]
    end

    def self.get
        @@instance ||= PlayerMaster.new

        return @@instance
    end

end
