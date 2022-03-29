
class MiniMap
  extend Publisher

  can_fire :center_viewport

  MINI_MAP_UPDATE_TIME = 200
  MINI_MAP_X = 850
  MINI_MAP_Y = 150
  SCALE = 0.08

  attr_accessor :fog
  attr_reader :image

  def initialize(map, viewport, entity_manager)
    @last_updated = 0
    @map = map
    @viewport = viewport
    @entity_manager = entity_manager

    surf = Surface.new [@map.pixel_width, @map.pixel_height]
    @map.draw_full surf
    @map_image = surf.zoom [SCALE,SCALE], true

    @w = @viewport.width * SCALE
    @h = @viewport.height * SCALE
    render
    @rect = Rect.new(MINI_MAP_X,MINI_MAP_Y,*@image.size)
  end

  def hit_by?(x,y)
    @rect.collide_point? x, y
  end


  def handle_mouse_click(x,y)
    fire :center_viewport, *translate_event_coords(x,y)
  end

  def handle_mouse_dragging(x,y)
    fire :center_viewport, *translate_event_coords(x,y)
  end

  def update(time)
    if @last_updated > MINI_MAP_UPDATE_TIME
      render
      @last_updated = 0
    else
      @last_updated += time
    end
  end

  def render()
    @image = Surface.new(@map_image.size)
    @map_image.blit @image, [0,0]

    local_id = @entity_manager.local_player.nil? ? -1 : @entity_manager.local_player.server_id
    for ent in @entity_manager.get_player_ents(local_id)
      entx = ent.x * SCALE
      enty = ent.y * SCALE
      @image.draw_circle_s [entx.floor,enty.floor], 1, RED
    end

    @fog.draw_minimap_fog @image if @fog

    x = SCALE * @viewport.x_offset
    y = SCALE * @viewport.y_offset
    @image.draw_box([x, y], [x+@w, y+@h], WHITE) 
  end
  
  protected
  def translate_event_coords(x,y)
    new_x = x / SCALE + @viewport.screen_x_offset
    new_y = y / SCALE + @viewport.screen_y_offset
    return new_x, new_y
  end
end

