
UnitWave = Struct.new(:unit_id, :length)


class WaveSystem
    INNER_WAVE_TIME = 0.25

    def update(dt)

        if !@started && @start_timer.update(dt)
            @started = true
        end

        if @started
            if @timer.update(dt)
                @wid += 1
                @timer.pause()
                @unit_timer.pause(false)
                @wave_finished = false

                if @wid >= @waves.size
                    @timer.stop!
                    @unit_timer.stop!
                end

            elsif @unit_timer.update(dt)
                what = @waves[@wid][@wave_sector]
                
                un = @world.create_unit( @x, @y, what.unit_id, @player )
                un.set_main_path(@tx, @ty)
                un.travel(@tx, @ty)
                @group.add(un)

                @sector_counter +=1

                if @sector_counter >= what.length
                    @sector_counter = 0
                    @wave_sector += 1
                    
                    if @wave_sector >= @waves[@wid].size
                        @wave_sector = 0
                        @wave_finished = true
                        @timer.pause(false)
                        @unit_timer.pause(true)
                    end
                end
            end
        end
    end

    def wait!
        @timer.pause()
        @unit_timer.pause()
        @start_timer.pause()
    end

    def resume!
        @timer.pause(false) if @wave_finished
        @unit_timer.pause(false) unless @wave_finished
        @start_timer.pause(false) unless @started
    end

    def summon!
        if @wid < @waves.size
            @timer.pause(false)
            @unit_timer.pause(false)
            @start_timer.pause(false)
        else
            @timer.stop!
            @unit_timer.stop!
            @start_timer.stop!
        end
    end

    def total_waves
        return @waves.size
    end

    def finished?
        return @wid >= @waves.size && @group.size <= 0
    end

    def finished_summoning?
        return @wave_finished
    end

    def group_empty?
        return @group.size <= 0
    end

    def wave_over?
        return @wave_finished && @group.size <= 0
    end

    def waiting?
        return @timer.paused?
    end

    def wave_number
        return @wid+1
    end

    def size
        return @waves.size
    end

    def set_target(tx, ty)
        @tx = tx
        @ty = ty
    end

    def initialize(x, y, player, startin, waves, wave_time, world)
        @wid = 0
        @waves = waves
        @x = x
        @y = y

        @tx = x
        @ty = y

        @wave_sector = 0
        @sector_counter = 0
        @world = world

        @wave_finished = false
        @started = false

        @player = player
        @group = UnitGroup.new()

        @paused = true
        @timer = SimpleTimer.new(wave_time, true, false)
        @unit_timer = SimpleTimer.new(INNER_WAVE_TIME, true, false)
        @start_timer = SimpleTimer.new(startin, false, false)
    end

end