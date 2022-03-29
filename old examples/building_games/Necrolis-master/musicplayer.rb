require 'gosu'

class MusicMaster
    @tracks = []

    def self.get
        @@inst ||= MusicMaster.new

        return @@inst
    end

    def setup
        fplace = Dir.pwd
        fplace = File.expand_path("music/", fplace)

        @tracks.push( Gosu::Song.new( File.expand_path("Tormented.ogg", fplace) ),
        Gosu::Song.new( File.expand_path("Slough_Of_Despond.ogg", fplace) ) )
    end

    def play
        @tracks[@id].play() if @id >= 0
    end

    def update
        if Gosu::Song.current_song == nil
            @id += 1
            if @id >= @tracks.size
                @id = 0
            end
            self.play
        end
    end

    def initialize
        @tracks = []
        @id = 0

        self.setup
    end

end
