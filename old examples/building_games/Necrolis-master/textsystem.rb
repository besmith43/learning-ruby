require 'gosu'

require_relative 'gconf'

class TextSystem
    attr_reader :scale

    def load(name)
        data = IO.readlines(name)

        data.each do |line|
            if line.start_with?(">")
                if @last_name != nil
                    @texts[@last_name][0].chomp!
                    @last_name = nil
                end
                if line.start_with?(">Message")
                    @last_name = line.split(" ")[1]
                    @texts[@last_name] = ["", nil]
                end
            elsif line.start_with?("#") || line.start_with?("--")

            elsif @last_name != nil
                sline = line
                if line.include?("&")
                    sline = sline.gsub("&", "")
                    sline.chomp!
                    #sline.chop!
                end
                @texts[@last_name][0] << sline
            end
        end
    end

    def get_text(name)
        return @texts[name][0]
    end

    def get_text_image(name)
        img = @texts[name][1]

        if img == nil
            img = Gosu::Image.from_text(self.get_text(name), 22, { :retro=>true, :width=>$game_window.width*0.8/@scale})
            @texts[name][1] = img
        end

        return img
    end

    def initialize
        @texts = Hash.new(["$ERROR: Text not found", nil])
        @last_name = nil
        @scale = 1
    end

end
