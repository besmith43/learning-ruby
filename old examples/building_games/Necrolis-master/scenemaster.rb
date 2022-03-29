
class SceneMaster

    def initialize
        @scenes = {}
        @cscene = nil
        @paused = nil
    end

    def button_down(bt)
        @cscene.button_down(bt) if @cscene
    end

    def button_up(bt)
        @cscene.button_up(bt) if @cscene
    end

    def push(scene)
        @scenes[scene.name] = scene
    end

    def find(name)
        return @scenes[name]
    end

    def play(name)
        prev = @cscene
        towards = name != nil ? @scenes[name] : nil
        @cscene.on_exit(towards) if @cscene
        @cscene = towards
        @cscene.on_enter(prev) if @cscene
    end

    def self.get
        @@myself ||=  SceneMaster.new()

        return @@myself
    end

    def current
        return @cscene
    end

    def update(dt)
        @cscene.update(dt) if @cscene && !@paused
    end

    def draw
        @cscene.draw() if @cscene
    end

end
