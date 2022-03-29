#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
require 'gosu'
require 'chipmunk'
require_relative 'boulder'
require_relative 'platform'
require_relative 'wall'
require_relative 'chip'
require_relative 'moving_platform'

class Escape < Gosu::Window
  DAMPING = 0.90
  GRAVITY = 400.0
  BOULDER_FREQUENCY = 0.01
  attr_reader :space
  def initialize
    super(800,800)
    self.caption = 'Escape'
    @game_over = false
    @space = CP::Space.new
    @background = Gosu::Image.new('images/background.png', tileable: true)
    @space.damping = DAMPING
    @space.gravity = CP::Vec2.new(0.0, GRAVITY)
    @boulders = []
    @platforms = make_platforms

    @floor = Wall.new(self, 400,810,800,20)
    @left_wall = Wall.new(self, -10, 400, 20,800)
    @right_wall = Wall.new(self, 810,470,20,660)
    @player = Chip.new(self,70,700)
    @sign = Gosu::Image.new('images/exit.png')
    @font = Gosu::Font.new(40)
  end
  def make_platforms
    platforms = []
    platforms.push Platform.new(self,150,700)
    platforms.push Platform.new(self,320,650)
    platforms.push Platform.new(self,150,500)
    platforms.push Platform.new(self,470,550)
    platforms.push MovingPlatform.new(self,580,600,70,:vertical)
    platforms.push Platform.new(self,320,440)
    platforms.push Platform.new(self,600,150)
    platforms.push Platform.new(self,700,450)
    platforms.push Platform.new(self,580,300)
    platforms.push MovingPlatform.new(self,190,330,50,:vertical)
    platforms.push MovingPlatform.new(self,450,230,70,:horizontal)
    platforms.push Platform.new(self,750,140)
    platforms.push Platform.new(self,700,700)
    return platforms
  end
  def draw
    @background.draw(0,0,0)
    @background.draw(0,529,0)
    @boulders.each do |boulder|
      boulder.draw
    end
    @platforms.each do |platform|
      platform.draw
    end
    @player.draw
    @sign.draw(650,30,1)
    if @game_over == false
      @seconds = (Gosu.milliseconds / 1000).to_i
      @font.draw("#{@seconds}", 10,20,3,1,1,0xff00ff00)
    else
      @font.draw("#{@win_time/1000}", 10,20,3,1,1,0xff00ff00)
      @font.draw("Game Over",200, 300, 3,2,2,0xff00ff00)
    end
  end
  def update
    unless @game_over
      10.times do 
        @space.step(1.0/600)
      end
      if rand < BOULDER_FREQUENCY 
        @boulders.push Boulder.new(self, 200 + rand(400), -20)
      end
      @player.check_footing(@platforms + @boulders)
      @platforms.each do |platform|
        platform.move if platform.respond_to?(:move)
      end
      if button_down?(Gosu::KbRight)
    	  @player.move_right
      elsif button_down?(Gosu::KbLeft)
        @player.move_left
      else
        @player.stand
      end
      if @player.x > 820
        @game_over = true
        @win_time = Gosu.milliseconds
      end
    end   
  end

  def button_down(id)
    if id == Gosu::KbSpace
      @player.jump
    end
    if id == Gosu::KbQ
      close
    end
  end
end

window = Escape.new
window.show
