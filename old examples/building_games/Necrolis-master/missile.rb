require_relative 'entity'

require_relative 'missiletype'


class Missile < CollisionEntity

    def is_dead?
        @dead
    end

    def update(dt)
        if @dist <= 0.25 || @hits <= 0
            @dead = true
        end

        if !@dead
            spd = @speed*dt
            self.move_pos( @cosx * spd, @siny * spd )
            @dist -= spd

            sx = ((@rect.x)/@home.space_hash.tile_x).to_i
            sy = ((@rect.y)/@home.space_hash.tile_y).to_i

            fx = ((@rect.x+@rect.w)/@home.space_hash.tile_x).to_i
            fy = ((@rect.y+@rect.h)/@home.space_hash.tile_y).to_i

            
            (sx..fx).each do |hpx|
                (sy..fy).each do |hpy|
                    @home.space_hash.get_grid(hpx, hpy).each do |tar|
                        if @owner.player.is_enemy?(tar.player) && !@collided.include?(tar) && tar.collides_with?(self)
                            @collided.add?(tar)
                            @hits -= 1
                            @owner.damage_target( tar, @damage )

                            if @hits <= 0
                                @dead = true
                                return
                            end
                        end
                    end
                end
            end

        end
    end

    def draw
        super
        @home.missile_texture[ @kind.graphid ].draw_rot(@x, @y, @z, @angle*57.3, 0.5, 0.5, @home.zoom_x-1, @home.zoom_y-1)
    end

    def self.create_xy(x1,y1,x2,y2,gid,owner,damage,home)
        dx = (x2-x1)
        dy = (y2-y1)
        dist = Math.sqrt( dx*dx + dy*dy )
        angle = Math.atan2( dy, dx )

        return Missile.new(x1,y1,angle,dist,gid,owner,damage,home)
    end

    def initialize(x1,y1,angle,dist,gid,owner,damage,home)
        super x1, y1, ZOrder::UNITS, home.tile_sx*0.75, home.tile_sy*0.75

        @owner = owner
        @home = home

        #@show_rect = true
        @kind = MissileMaster.get.bring(gid)

        @damage = damage
        @dead = false

        @dist = dist
        @angle = angle
        @cosx = Math.cos(angle)
        @siny = Math.sin(angle)

        @collided = Set.new()

        @speed = @kind.speed * home.tile_prom
        @hits = @kind.hits
    end

end

