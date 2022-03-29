require_relative 'world'


class World2 < World
    STATES = [ "Start", "Summon", "Enemies", "Archers", "More", "Last", "Victory" ]

    def update(dt) 
        super(dt)
        game_logic(dt)

        if @state == 0 || @state == 6
            self.next_text() if @adv_timer.update(dt)
        elsif @state == 1
            if @units.size > 3
                self.next_text()
            end
        elsif @state == 2 || @state == 3
            if @wavesys.wave_number == @state-1 && @wavesys.finished_summoning?
                @wavesys.wait!
                if @wavesys.group_empty?
                    self.next_text()
                end
            end
        elsif @state == 4
            self.next_text() if @wavesys.wave_number == @wavesys.total_waves-1
        elsif @state == 5
            if @wavesys.finished? #@wavesys.wave_number == @wavesys.total_waves &&  @wavesys.group_empty?
                self.next_text()
            end
        end

    end

    def next_text()
        @state += 1

        self.set_message( STATES[@state] ) if @state < STATES.size

        if @state == 1
            PlayerMaster.PLAYER_1.energy += UnitMaster.get.energy_cost(UnitMaster::ZOMBIE)*2
            PlayerMaster.PLAYER_1.corpses += 2
        elsif @state == 2
            @wavesys.summon!
        elsif @state == 3
            @wavesys.resume!
        elsif @state == 4
            @wavesys.resume!
            PlayerMaster.PLAYER_1.energy += UnitMaster.get.energy_cost(UnitMaster::SKELETON)*2
            PlayerMaster.PLAYER_1.corpses += 2
        elsif @state == 6
            @adv_timer.set_time(5)
        elsif @state == 7
            @victory=true
        end
    end

    def load
        super

        reg = @regions["hstart"]
        targ = @regions["target"]
        @wavesys = self.create_wave_system(reg, PlayerMaster::P2, 10.0, targ.centerx, targ.centery)

        @state = -1
        @adv_timer = SimpleTimer.new(25, true)

        self.add_summon( UnitMaster::SKELETON )
        self.add_summon( UnitMaster::ZOMBIE )

        self.next_text()
    end

end
