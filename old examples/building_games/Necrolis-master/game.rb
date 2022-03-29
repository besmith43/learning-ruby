require 'gosu'

require_relative 'scenemaster'
require_relative 'sceneplay'

require_relative 'gconf'

# Create the GameWindow
class GameWindow < Gosu::Window

    FULLSCREEN = false

    def update
        ndt = Gosu::milliseconds()
        dt = ndt - @prevdt
        @prevdt = ndt

        if dt < 35
            SceneMaster.get.update(dt/1000.0)
        end

    end

    def button_down(bt)
        SceneMaster.get.button_down(bt)
    end

    def button_up(bt)
        SceneMaster.get.button_up(bt)
    end

    def draw
        SceneMaster.get.draw()
    end

    def needs_cursor?
        true
    end

    def end_game
        self.close
    end

    def initialize
        super SCREEN_WIDTH, SCREEN_HEIGHT, FULLSCREEN if !FULLSCREEN
        super Gosu::screen_width, Gosu::screen_height, FULLSCREEN if FULLSCREEN

        self.caption = "Necrolis"

        @prevdt = 0.0

        $game_window = self

        SceneMaster.get.push(ScenePlay.new(self))
        SceneMaster.get.play("PLAY")
    end

end

GameWindow.new.show