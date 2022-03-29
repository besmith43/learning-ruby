

class MissileType
    attr_reader :graphid, :speed, :hits

    def initialize(graphid, speed, hits)
        @graphid = graphid
        @speed = speed
        @hits = hits.to_i
    end

end



class MissileMaster
    @@inst = nil
    ARROW = 0

    def initialize
        @missiles = []
    end

    def bring(id)
        return @missiles[id]
    end

    def setup
        arrow = MissileType.new(0, 4.0, 1)

        @missiles = [arrow]
    end

    def self.get
        @@inst ||= MissileMaster.new

        return @@inst
    end

end
