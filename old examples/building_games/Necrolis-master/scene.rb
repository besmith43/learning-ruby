require_relative 'scenemaster'

class Scene
    attr_reader :name, :game

    def update(dt)
    end

    def draw()
    end

    def button_down(bt)
    end

    def button_up(bt)
    end

    def on_enter(from)
    end
    
    def on_exit(towards)
    end

    def switch(to)
        if to.is_a?(String)
            SceneMaster.get.play(to)
        elsif to.is_a?(Scene)
            SceneMaster.get.play(to.name)
        end
    end

    def initialize(name, game)
        @name = name
        @game = game
    end

end
