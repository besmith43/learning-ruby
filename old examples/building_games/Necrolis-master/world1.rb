require_relative 'world'


class World1 < World

    def update(dt) 
        super(dt)
        game_logic(dt)

        @wavesys.update(dt)

        if @state == 0 || @state == 1 || @state == 8
            self.next_text() if @adv_timer.update(dt)
        elsif @state == 2
            if @units.size > 0
                self.next_text()
            end
        elsif @state == 3
            if @units.first.is_moving?
                @adv_timer.pause(false)
            end

            self.next_text() if @adv_timer.update(dt)
        elsif @state == 4
            if @units.size > 2
                self.next_text()
            end
        elsif @state == 5
            if @wavesys.wave_number == 2 && @wavesys.finished_summoning?
                @wavesys.wait!
                if @wavesys.group_empty?
                    self.next_text()
                end
            end
        elsif @state == 6
            self.next_text() unless @wavesys.group_empty?
        elsif @state == 7
            if @wavesys.group_empty?
                self.next_text()
            end
        end
    end

    def next_text()
        @state += 1
    
        if @state == 1
            self.set_message("Base")
        elsif @state == 2
            PlayerMaster.PLAYER_1.energy += UnitMaster.get.bring(UnitMaster::SKELETON).energy_cost
            PlayerMaster.PLAYER_1.corpses += UnitMaster.get.bring(UnitMaster::SKELETON).corpses_cost
            self.add_summon( UnitMaster::SKELETON )
            self.set_message("Summon")
        elsif @state == 3
            self.set_message("Orders")
            @adv_timer.pause()
            @adv_timer.set_time(5.0)
        elsif @state == 4
            self.set_message("MoreSummoning")
            PlayerMaster.PLAYER_1.energy += UnitMaster.get.bring(UnitMaster::SKELETON).energy_cost*2
            PlayerMaster.PLAYER_1.corpses += UnitMaster.get.bring(UnitMaster::SKELETON).corpses_cost*2
        elsif @state == 5
            self.set_message("Enemies")
            @wavesys.summon!
        elsif @state == 6
            self.set_message("AlmostOver")
            @wavesys.resume!
            PlayerMaster.PLAYER_1.energy += UnitMaster.get.bring(UnitMaster::SKELETON).energy_cost
        elsif @state == 7
            self.set_message("FinalBattle")
        elsif @state == 8
            @adv_timer.set_time(4.0)
            self.set_message("Victory")
        elsif @state == 9
            @adv_timer.pause()
            @victory = true
        end

    end

    def load
        super

        reg = @regions["hstart"]
        targ = @regions["target"]
        @wavesys = self.create_wave_system(reg, PlayerMaster::P2, 1.0, targ.centerx, targ.centery)

        @state = 0
        @adv_timer = SimpleTimer.new(20, true)

        self.set_message("Start")
    end

end
