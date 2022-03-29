

class SceneMenu < Scene

    def button_down(bt)
        if bt == Gosu::KbEnter
            self.switch("PLAY")
        end
    end

    def initialize(game)
        super "MENU", game
    end

end