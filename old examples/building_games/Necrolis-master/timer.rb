

class SimpleTimer

    def pause(state=true)
        @paused = state
    end

    def paused?
        return @paused
    end

    def set_time(t)
        @time = t
        @max_time = t
    end

    def stop!
        self.pause
        @time = @max_time
    end

    def update(dt)
        if !@paused
            @time -= dt

            if @time <= 0
                @time = @max_time
                @paused = true if !@repeat
                return true
            end
        end

        return false
    end

    def initialize(time, repeat=true, auto_start=true)
        @time = time
        @max_time = time

        @repeat = repeat
        @paused = !auto_start
    end

end