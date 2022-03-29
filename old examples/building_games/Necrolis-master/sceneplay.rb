require_relative 'scene'
require_relative 'world1'
require_relative 'world2'
require_relative 'world3'

require_relative 'musicplayer'

class ScenePlay < Scene
    ENERGY_SUMMON_BASE = 25
    START_AT = 0

    def can_use_energy?
        return PlayerMaster.PLAYER_1.energy > ENERGY_SUMMON_BASE
    end

    def button_down(bt)
        if bt == Gosu::MsLeft
            @world.unselect_all()

            if @selected_spell != nil
                res = true

                @selected_spell.on_cast(@world.camerax+@game.mouse_x, @world.cameray+@game.mouse_y,PlayerMaster.PLAYER_1)
            end
        elsif bt == Gosu::MsRight
            @world.selected.each {|u| u.travel(@world.camerax+@game.mouse_x, @world.cameray+@game.mouse_y)}
        elsif bt == Gosu::KbEscape
            @game.end_game
        elsif bt == Gosu::KbSpace
            @slowed = !@slowed
            @time_mult = @slowed? 0.5 : 1.0
        elsif bt == Gosu::KbS
            if @selected_summon == nil
                summ = @world.get_summon_by_pos(0)
                if summ != nil
                    @selected_summon = UnitMaster.get.bring(summ)
                    #@world.unselect_all()
                end
            else
                @selected_summon = nil
            end
        elsif bt == Gosu::KbH
            @world.swap_message()
        end

        if @selected_summon != nil
            if bt == Gosu::Kb1
                id = @world.get_summon_by_pos(0)
                @selected_summon = UnitMaster.get.bring(id) if id != nil
            elsif bt == Gosu::Kb2
                id = @world.get_summon_by_pos(1)
                @selected_summon = UnitMaster.get.bring(id) if id != nil
            elsif bt == Gosu::Kb3
                id = @world.get_summon_by_pos(2)
                @selected_summon = UnitMaster.get.bring(id) if id != nil
            end
        end
    end

    def update(dt)
        @world.update(dt * @time_mult)


        if @selected_summon != nil
            if !@world.can_summon?(@selected_summon.id)
                @selected_summon = nil
            elsif Gosu::button_down?(Gosu::MsLeft)
                res = true
                @world.units.each do |un|
                    if un.contains?(@game.mouse_x + @world.camerax, @game.mouse_y + @world.cameray)
                        res = false
                        break
                    end
                end

                if res && @world.summonable_pos?(@game.mouse_x + @world.camerax, @game.mouse_y + @world.cameray) && PlayerMaster.PLAYER_1.energy >= @selected_summon.energy_cost+ENERGY_SUMMON_BASE && PlayerMaster.PLAYER_1.corpses >= @selected_summon.corpses_cost
                    newun = @world.create_unit(@game.mouse_x + @world.camerax, @game.mouse_y + @world.cameray, @selected_summon, PlayerMaster::P1)
                    PlayerMaster.PLAYER_1.energy -= @selected_summon.energy_cost
                    PlayerMaster.PLAYER_1.corpses -= @selected_summon.corpses_cost
                    @world.select(newun)
                end
            end
        elsif @selected_spell != nil
            if !@world.can_summon?(@selected_spell)
                @selected_spell = nil
            end
        else
            if Gosu::button_down?(Gosu::MsLeft)
                @world.units.each do |u|
                    if u.player.pid == PlayerMaster::P1 && u.rect.contains?( @world.camerax+@game.mouse_x, @world.cameray+@game.mouse_y )
                        @world.select( u )
                    end
                end
            end
        end

        @world.restart() if @world.lost?
        self.next_level() if @world.won?
    end

    def draw
        ener = PlayerMaster.PLAYER_1.energy
        corp = PlayerMaster.PLAYER_1.corpses
        @world.draw()

        if ener > ENERGY_SUMMON_BASE
            @scenefont.draw_rel( "Energy: #{ener}", @game.width*0.2, 4, ZOrder::UI, 0.5, 0 )
        else
            @scenefont.draw_rel( "Energy: #{ener}", @game.width*0.2, 4, ZOrder::UI, 0.5, 0, 1, 1, Gosu::Color::RED )
        end

        @scenefont.draw_rel( "Corpses: #{corp}", @game.width*0.8, 4, ZOrder::UI, 0.5, 0 )

        if @selected_summon != nil
            @world.unit_texture[ @selected_summon.graphid ].draw_rot( @game.mouse_x, @game.mouse_y, ZOrder::SUMMONS, 0, 0.5, 0.5, @world.zoom_x, @world.zoom_y )
        elsif @selected_spell != nil
            @world.spell_texture[ @selected_spell.graphic ].draw_rot( @game.mouse_x, @game.mouse_y, ZOrder::SUMMONS, 0, 0.5, 0.5, @world.zoom_x, @world.zoom_y )
        end

    end

    def set_level(id)

        @current_world = id

        if @current_world >= @worlds.size
            puts "Victory"
            @game.end_game
        else
            @world.clear unless @world==nil
            @world = @worlds[@current_world]
            @world.load()
            MusicMaster.get.play()
        end
    end

    def next_level
        self.set_level(@current_world+1)
    end

    def initialize(game)
        super "PLAY", game

        PlayerMaster.get.setup()
        MissileMaster.get.setup()
        UnitMaster.get.setup()
        EffectMaster.get.setup()
        
        @current_world = 0
        
        @world = nil
        world1 = World1.new("Clooksan", "map1.json", "map1.txt", self)
        world2 = World2.new("Blanhis", "map2.json", "map2.txt", self)
        world3 = World3.new("Mulahay", "map3.json", "map3.txt", self)
        @worlds = [world1, world2, world3]

        @time_mult = 1.00
        @slowed = false
        @selected_summon = nil
        @selected_spell = nil

        @scenefont = Gosu::Font.new(24)

        self.set_level(START_AT)
    end

end
