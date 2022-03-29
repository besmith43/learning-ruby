require 'json'
require 'set'

require_relative 'shape'
require_relative 'region'
require_relative 'unit'

require_relative 'draworder'
require_relative 'timer'
require_relative 'textsystem'

require_relative 'spacehash'

require_relative 'missile'
require_relative 'wavesystem'

require_relative 'effect'

class World
    attr_reader :tile_sx, :tile_sy, :tile_sqx, :tile_sqy, :zoom_x, :zoom_y, :graph_sx, :graph_sy, :effect_texture, 
    :missile_texture, :unit_texture, :units, :camerax, :cameray, :selected, :space_hash, :scene

    DEAD_LAND = 1
    TEXT_RECT_COLOR = Gosu::Color.new(192, 96, 64, 64)


    def show_message(how=true)
        @show_messages = how
    end

    def set_message(wich)
        @current_text_image = wich != nil ? @textsystem.get_text_image(wich) : nil
    end

    def swap_message
        self.show_message(!@show_messages)
    end

    def energy_base
        return @scene.class::ENERGY_SUMMON_BASE
    end

    def create_wave_system(region, player, startin, tx=nil, ty=nil)
        pos = region.center
        wavs = WaveSystem.new( pos[0], pos[1], player, startin, region.get_prop("wave_list", []), region.get_prop("wave_time", 30.0), self )


        wavs.set_target( tx == nil ? pos[0] : tx, ty == nil ? pos[1] : ty )

        @wave_systems.push(wavs)

        return wavs
    end

    def parse_spawn_region(reg)
        wave_amm = reg.get_prop("waves", false)

        if wave_amm != false
            swaves = []
            waves = []

            wave_amm.times do |t|
                twave = reg.get_prop("w#{t+1}", nil)
                swaves.push( twave.gsub(" ", "").split(",") ) if twave != nil
            end

            swaves.each do |twave|
                nadd = []
                twave.each do |wave_unit|
                    unstr = wave_unit.split(":")
                    nadd.push( UnitWave.new( UnitMaster.get.by_name(unstr[0]).id, unstr[1].to_i ) )
                end
                waves.push(nadd)
            end

            reg.set_prop("wave_list", waves)
            reg.set_prop("wave_time", reg.get_prop("wave_time", 30.0))
        end
    end

    def move_camera(x,y)
        @camerax += x
        @cameray += y
    end

    def can_use_energy?
        return PlayerMaster.PLAYER_1.energy > @scene.ENERGY_SUMMON_BASE
    end

    def select(who)
        @selected.add?(who)
        who.show_rectangle(true)
    end

    def unselect(who)
        @selected.delete?(who)
        who.show_rectangle(false)
    end

    def unselect_all
        @selected.each { |u| u.show_rectangle(false) }
        @selected.clear()
    end


    def process_events(dt)
        speed = 12

        if Gosu::button_down?(Gosu::KbLeft)
            self.move_camera(@tile_sx*-speed*dt, 0)
        elsif Gosu::button_down?(Gosu::KbRight)
            self.move_camera(@tile_sx*speed*dt, 0)
        end

        if Gosu::button_down?(Gosu::KbUp)
            self.move_camera(0, @tile_sy*-speed*dt)
        elsif Gosu::button_down?(Gosu::KbDown)
            self.move_camera(0, @tile_sy*speed*dt)
        end
    end

    def any_unit_xy?(x,y)
        @units.each do |u|
            if u.contains?(x,y)
                return u
            end
        end

        return nil
    end

    def any_player_unit_xy?(x,y,player)
        id = player.instance_of?(Player) ? player.id : player

        @units.each do |u|
            if u.contains?(x,y) && u.player.id == id
                return u
            end
        end

        return nil
    end

    def update(dt)
        if @loaded
            self.process_events(dt)

            @wave_systems.each { |ws| ws.update(dt) }

            @units.delete_if do |u|
                u.update(dt) unless u.is_dead?
                u.is_dead?
            end

            @missiles.delete_if do |u|
                u.update(dt) unless u.is_dead?
                u.is_dead?
            end

            @effects.delete_if do |u|
                u.update(dt) unless u.is_dead?
                u.is_dead?
            end
        end
    end

    def draw
        if @loaded
            Gosu::translate(-@camerax, -@cameray){
                @world_texture.draw( 0, 0, ZOrder::TILESET )

                @units.each { |u| u.draw }
                @missiles.each { |m| m.draw }
                @effects.each { |e| e.draw }
                #@space_hash.draw
            }

            

            if @show_messages && @current_text_image != nil
                gw = @scene.game.width*0.1
                Gosu::draw_rect(gw-4, @scene.game.height-@current_text_image.height*@textsystem.scale, @scene.game.width-gw*@textsystem.scale*2+8, @current_text_image.height*@textsystem.scale, TEXT_RECT_COLOR, ZOrder::TEXTS)
                @current_text_image.draw_rot(gw, @scene.game.height, ZOrder::TEXTS, 0, 0, 1, @textsystem.scale, @textsystem.scale)
            end
        end
    end

    def clear
        @units = nil
        @missiles = nil
        @matrix = nil
        @unit_texture = nil
        @regions = nil
        @wave_systems = nil
        @missile_texture = nil
        @world_texture = nil
        @space_hash = nil
        @effects = nil

        UnitGroup.clear

        @victory = false
        @defeat = false

        @energy = 0
        @corpses = 0
    end

    def game_logic(dt)
        p1 = PlayerMaster.get.bring(PlayerMaster::P1)
        if @energy_timer.update(dt)
            @units.each do |un|

                if un.player.is_enemy?(p1) && self.summonable_pos?(un.x, un.y)
                    PlayerMaster.PLAYER_1.energy -= 1
                end
            end
        end

        if PlayerMaster.PLAYER_1.energy <= 0
            @defeat = true
        end
    end

    def walkable_tile?(x,y)
        return @borders.contains?(x,y)
    end

    def walkable?(x,y)
        return @bounds.contains?(x,y)
    end

    def create_region(name, x, y, w, h, properties)
        reg = Region.new( name, x*@tile_sx, y*@tile_sy, w*@tile_sx, h*@tile_sy, properties )
        @regions[name] = reg
        self.parse_spawn_region(reg)

        return reg
    end

    def create_unit(x, y, gid, player, properties={})
        un = Unit.new(x, y, gid, player, properties, self)
        @units.push( un )

        return un
    end

    def create_missile_xy(x1,y1,x2,y2,gid,owner,damage)
        mis = Missile.create_xy(x1,y1,x2,y2,gid,owner,damage,self)
        @missiles.push(mis)

        return mis
    end

    def create_effect(x,y,kind,target=nil)
        eff = Effect.new(x,y,kind,self)
        eff.attach(target)
        @effects.push(eff)

        return eff
    end

    def summonable_pos?(x,y)
        xp = (x/@tile_sx).to_i
        yp = (y/@tile_sy).to_i

        @matrix.each do |mat|
            return true if mat[xp][yp] == DEAD_LAND
        end

        return false
    end

    def won?
        @victory
    end

    def tile_prom
        return (@tile_sx+@tile_sy)/2
    end

    def lost?
        @defeat
    end

    def restart
        self.clear
        self.load
    end

    def add_summon(who)
        @summon_list.push(who) unless @summon_list.include?(who)
    end

    def rem_summon(who)
        @summon_list.delete(who)
    end

    def get_summon_by_pos(key)
        return @summon_list.size > key ? @summon_list[key] : nil
    end

    def can_summon?(who)
        return @summon_list.include?(who)
    end

    def can_cast?(what)
        return @spell_list.include?(what)
    end

    def get_spell_by_pos(key)
        return @spell_list.size > key ? @spell_list[key] : nil
    end

    def rem_spell(what)
        @spell_list.delete(what)
    end

    def add_spell(what)
        @spell_list.push(what) unless @spell_list.include?(who)
    end

    def load_texts()
        where = File.expand_path("maps/", Dir.pwd)
        @textsystem.load( File.expand_path(@textpath, where) )

        self.show_message
    end

    def get_player_units(pid)
        ret = []
        @units.each do |u|
            ret.push(u) if u.player.id == pid
        end

        return ret
    end

    def get_units_of_type(utype)
        ret = []
        @units.each do |u|
            ret.push(u) if u.kind.id==utype
        end

        return ret
    end

    def get_player_units_of_type(pid, utype)
        ret = []
        @units.each do |u|
            ret.push(u) if u.player.id == pid && u.kind.id==utype
        end

        return ret
    end

    def load
        fplace = Dir.pwd
        fplace = File.expand_path("maps/", fplace)

        file = File.read( File.expand_path(@loadpath, fplace) )
    
        data = JSON.parse(file)
        
        @borders = Rectangle.new(0,0,data['width'],data['height'])
        @bounds = Rectangle.new(0,0,@borders.w*@tile_sx,@borders.h*@tile_sy)

        @matrix = [] #Array.new( ttx ){ Array.new(tty, -1) }

        @missiles = []
        @units = []
        @effects = []

        @regions = {}

        @summon_list = []
        @spell_list = []

        @selected = Set.new()
        @textsystem = TextSystem.new()

        @space_hash = SpaceHash.new( @bounds, SpaceHash::CELL_SIZE, SpaceHash::CELL_SIZE )

        @show_messages = false

        @camerax = 0
        @cameray = 0

        @victory = false
        @defeat = false

        @wave_systems = []

        gph = File.expand_path("graphics/", Dir.pwd)
        utl = File.expand_path("units.png", gph)
        mtl = File.expand_path("missiles.png", gph)
        etl = File.expand_path("effects.png", gph)

        @tileset = Gosu::Image.load_tiles( File.expand_path("tileset.png", gph), @graph_sx, @graph_sy, :retro=>true )

        @unit_texture = Gosu::Image.load_tiles(utl, @graph_sx, @graph_sy, :retro=>true )

        @missile_texture = Gosu::Image.load_tiles(mtl, @graph_sx, @graph_sy, :retro=>true)

        @effect_texture = Gosu::Image.load_tiles(etl, @graph_sx, @graph_sy, :retro=>true)

        @unit_image_width = Gosu::Image.new( utl ).width

        world_properties = data.fetch('properties', {})

        PlayerMaster.PLAYER_1.energy = world_properties.fetch( 'energy', self.energy_base )
        PlayerMaster.PLAYER_1.corpses = world_properties.fetch( 'corpses', 0 )

        @summon_list = []

        sumlist = world_properties.fetch('summons', "").gsub(" ", "").split(",")
        
        sumlist.each do |u|
            @summon_list.push( UnitMaster.get.by_name(u).id )
        end

        data['layers'].each do |lay|
            name = lay['name']

            if lay['type'] == "tilelayer"
                props = lay.fetch('properties', {})
                
                x=0
                y=0
                tt=0
                
                matx = Array.new( @borders.w ){ Array.new(@borders.h, -1) }
                
                lay['data'].each do |tid|
                    x=(tt % @borders.w).to_i
                    y=(tt / @borders.w).to_i
                    
                    matx[x][y] = tid-1
                    
                    tt+=1
                end

                @matrix.push(matx)
            elsif lay['type'] == "objectgroup"
                if name == "regions"
                    lay['objects'].each do |obj|
                        self.create_region( obj['name'], obj['x'] / @graph_sx , obj['y'] / @graph_sy,
                         obj['width'] / @graph_sx, obj['height'] /@graph_sy, obj['properties'] )
                    end
                elsif name == "units"
                    lay['objects'].each do |obj|
                        self.create_unit((obj['x']+0.5) * (@tile_sx/@graph_sx), ( (obj['y']+0.5) * (@tile_sy/@graph_sy))-1, obj['gid']-1, obj['properties'].fetch("player", PlayerMaster::P1), obj['properties'] )
                    end
                end
                
            end
        end

        @world_texture = Gosu::record(@borders.w*@zoom_x, @borders.h*@zoom_y){
            @matrix.size.times do |z|
                @borders.w.times do |x|
                    @borders.h.times do |y|
                        tid = @matrix[z][x][y]
                        @tileset[tid].draw(x*@tile_sx, y*@tile_sy, ZOrder::TILESET, @zoom_x, @zoom_y) if tid >= 0
                    end
                end
            end
        }

        @camerax = @bounds.w/2 - @scene.game.width/2
        @cameray = @bounds.h/2 - @scene.game.height/2

        self.load_texts() if @textpath != nil

        @loaded = true
    end

    def max_layer_z
        return @matriz.size
    end

    def initialize(name, loadpath, textpath, scene)
        @name = name
        @loadpath = loadpath
        @textpath = textpath

        #===
        # Just to have an idea what are we going to need up there
        #===
        @tileset = nil
        @unit_texture = nil
        @world_texture = nil
        @missile_texture = nil

        @scene = scene

        @units = nil
        @missiles = nil
        @regions = nil

        @selected = nil
        @textsystem = nil

        @show_messages = false
        @current_text_image = nil

        @matrix = nil
        @borders = nil

        @bounds = nil

        @camerax = 0
        @cameray = 0

        @graph_sx = 4
        @graph_sy = 4

        @zoom_x = 6
        @zoom_y = 6

        @tile_sx = @graph_sx*@zoom_x
        @tile_sy = @graph_sy*@zoom_y

        @tile_sqx = @tile_sx*@tile_sx
        @tile_sqy = @tile_sy*@tile_sy

        @unit_image_width = 1

        @victory = false
        @defeat = false

        @summon_list = nil
        @spell_list = nil

        @energy_timer = SimpleTimer.new(1.0, true)

        @wave_systems = nil

        @space_hash = nil
        #===

        @loaded = false
    end

end

