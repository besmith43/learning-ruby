
class UnitStats
    attr_accessor :health, :damage, :armor, :attack_speed, :move_speed, :sight_range, :range, :missile

    def initialize(hp, dmg=1, arm=0, aspd=1, mspd=1, sran=2, ran=1, missile=nil)
        if hp.is_a?(UnitStats)
            dmg,arm,aspd,mspd,sran,ran,missile = hp.damage,hp.armor,hp.attack_speed,hp.move_speed,hp.sight_range,hp.range,hp.missile
            hp = hp.health
        end

        @health,@damage,@armor,@attack_speed,@move_speed,@sight_range,@range,@missile=hp,dmg,arm,aspd,mspd,sran,ran,missile
    end

end


class UnitType
    attr_reader :id, :name, :stats, :graphid, :energy_cost, :corpses_cost

    # move_speed = TILES_PER_SECOND
    # attack_speed = SECONDS_PER_ATTACK
    # sight_range = TILES_SEEN
    # range = MAX_TILES_ATTACK_DISTANCE

    def initialize(id, rid, name, stats, ecost=15, ccost=1)
        @id = id
        @graphid = rid

        @name = name

        @stats = stats
        @energy_cost = ecost
        @corpses_cost = ccost
    end

end

class UnitMaster
    SKELETON = 18
    SOLDIER = 19
    ZOMBIE = 20
    ARCHER = 21

    def initialize
        @everyone = {}
    end

    def add(who)
        @everyone[who.id] = who
    end

    def setup
        move = :move
        attack = :attack
        melee = 1.1

        fplace = Dir.pwd
        fplace = File.expand_path("data/", fplace)

        data = IO.readlines(File.expand_path("unitstats.txt", fplace))
        last_unit = nil

        toadd = []

        data.each do |line|
            line.chomp!

            if line.start_with?("#") || line.start_with?("--")
                #Ignore
            elsif line.start_with?("CREATE")
                toadd.push( last_unit ) if last_unit != nil

                name = line.split(" ")[1]
                last_unit = {"NAME"=>name}
            elsif line.start_with?("FINISH")
                toadd.push( last_unit ) if last_unit != nil
                last_unit = nil
            elsif last_unit != nil
                info = line.split(" ")
                last_unit[info[0].upcase] = info[1]
            end
        end

        toadd.each do |untype|
            name = untype["NAME"]
            tileid = untype.fetch("TILE", SKELETON).to_i
            graphid = untype.fetch("GRAPHIC", 0).to_i*4
            health = untype.fetch("HEALTH", 2).to_i
            armor = untype.fetch("ARMOR", 0).to_i
            damage = untype.fetch("DAMAGE", 1).to_i
            atk_spd = untype.fetch("ATTACK_SPEED", 1.1).to_f
            mov_spd = untype.fetch("MOVE_SPEED", 2.0).to_f
            sight_range = untype.fetch("SIGHT_RANGE", 5).to_f
            atk_range = untype.fetch("ATTACK_RANGE", melee).to_f
            miss_type = untype.fetch("MISSILE", "NONE")
            miss_type = miss_type.eql?("NONE")? nil : miss_type.to_i
            enercost = untype.fetch("ENERGY_COST", 15).to_i
            corpcost = untype.fetch("CORPSES_COST", 1).to_i

            #puts name, tileid, graphid, health, armor, damage, atk_spd, mov_spd, sight_range, atk_range, miss_type, enercost, corpcost
            self.add(UnitType.new(tileid, graphid, name, UnitStats.new(health,damage,armor,atk_spd,mov_spd,sight_range,atk_range,miss_type), enercost, corpcost))
        end
    end

    def bring(id)
        return @everyone[id]
    end

    def by_name(name)
        @everyone.each_value do |v|
            return v if v.name == name
        end

        return nil
    end

    def energy_cost(who)
        bring(who).energy_cost
    end

    def corpses_cost(who)
        bring(who).corpses_cost
    end

    def self.get
        @@myself ||= UnitMaster.new()

        return @@myself
    end

end
