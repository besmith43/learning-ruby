require_relative 'world'


class World3 < World
    STATES = [ "Start", "Ready", "Spell", "Waves", "Victory" ]

    def update(dt) 
        super(dt)
        game_logic(dt)

        if @state == 0 || @state == 4
            self.next_text() if @adv_timer.update(dt)
        elsif @state == 1
            self.next_text() if (@startsize-@enemygroup.size) > 2
        elsif @state == 2
            self.next_text() if @enemygroup.empty?
        elsif @state == 3
            self.next_text() if @wavesys1.finished? && @wavesys2.finished?
        end

    end

    def next_text()
        @state += 1

        self.set_message( STATES[@state] ) if @state < STATES.size

        if @state == 1
            PlayerMaster.PLAYER_1.energy += UnitMaster.get.energy_cost(UnitMaster::ZOMBIE)*3
            PlayerMaster.PLAYER_1.corpses += 3
        elsif @state == 2
            PlayerMaster.PLAYER_1.energy += UnitMaster.get.energy_cost(UnitMaster::SKELETON)*2
        elsif @state == 3
            @wavesys1.summon!
            @wavesys2.summon!
        elsif @state == 4
            @adv_timer.set_time(5)
        elsif @state == 5
            @victory = true
        end
    end

    def load
        super

        reg1 = @regions["hstart1"]
        reg2 = @regions["hstart2"]
        targ = @regions["target"]

        @wavesys1 = self.create_wave_system(reg1, PlayerMaster::P2, 10.0, targ.centerx, targ.centery)
        @wavesys2 = self.create_wave_system(reg2, PlayerMaster::P2, 10.0, targ.centerx, targ.centery)

        @state = -1
        @adv_timer = SimpleTimer.new(20, true)

        @enemygroup = UnitGroup.new()

        @enemygroup.add_units( self.get_player_units(PlayerMaster::P2) )
        @startsize = @enemygroup.size

        self.add_summon( UnitMaster::SKELETON )
        self.add_summon( UnitMaster::ZOMBIE )

        self.next_text()
    end

end
