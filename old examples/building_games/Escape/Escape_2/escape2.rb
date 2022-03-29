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
require_relative 'camera'
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
    @space = CP::Space.new
    @player = Chip.new(self, 70, 1500)
    @camera = Camera.new(self, 1600, 1600)
    @camera.center_on(@player, 400, 200)
    @game_over = false
    @background = Gosu::Image.new('images/background.png', tileable: true)
    @space.damping = DAMPING
    @space.gravity = CP::Vec2.new(0.0, GRAVITY)
    @boulders = []
    @platforms = make_platforms
    @floor = Wall.new(self, 800, 1610, 1600, 20)
    @left = Wall.new(self,-10, 800, 20, 1600)
    @right = Wall.new(self, 1610, 870, 20, 1460)
    #END_HIGHLGIHT
    @sign = Gosu::Image.new('images/exit.png')
    @font = Gosu::Font.new(40)
    @font_small = Gosu::Font.new(18)
    @music = Gosu::Song.new('sounds/zanzibar.ogg')
    @music.play(true)
    @quake_time = 0
    @quake_sound = Gosu::Sample.new('sounds/quake.ogg')
  end
  def draw
    @camera.view do
      (0..3).each do |row|
        (0..1).each do |column|
          @background.draw(799 * column, 529 * row, 0)
        end
      end
      @sign.draw(1450, 30, 2)
      @player.draw
      @boulders.each do |boulder|
        boulder.draw
      end
      @platforms.each do |platform|
        platform.draw
      end
    end
    if @game_over == false
      @font.draw("#{@seconds}", 10, 20, 3, 1, 1, 0xff00ff00)
    else
      @font.draw("#{@win_time/1000}", 10, 20, 3, 1, 1, 0xff00ff00)
      draw_credits
    end
  end
  def draw_credits
    color = 0xff00ff00
    @font.draw('Game Over',240, 150, 3, 2, 2, color)
    @font_small.draw('Images from the SpriteLib Collection',
                        100, 300, 3, 2, 2, color)
    @font_small.draw('by WidgetWorx under the terms of the',
                        100, 350, 3, 2, 2, color)
    @font_small.draw('Common Public License.',
                        100, 400, 3, 2, 2, color)
    @font_small.draw('Music:  Zanzibar, by Kevin MacLeod',
                        100, 500, 3, 2, 2, color)
    @font_small.draw('(incompetech.com)',
                        100, 550, 3, 2, 2, color)
    @font_small.draw('Licensed under',
                        100, 600, 3, 2, 2, color)
    @font_small.draw('Creative Commons: By Attribution 3.0',
                        100, 650, 3, 2, 2, color)
    @font_small.draw('http://creativecommons.org/licenses/by/3.0/',
                        100, 700, 3, 2, 2, color)
  end
  def make_platforms
    platforms = []
    (0..10).each do |row|
      (0..4).each do |column|
        x = column * 300 + 200
        y = row * 140 + 100
        if row % 2 == 0
          x -= 150
        end
        x += rand(100) - 50
        y += rand(100) - 50
        num = rand 
        if num < 0.40
           direction = rand < 0.5 ? :vertical : :horizontal
           range = 30 + rand(40)
           platforms.push MovingPlatform.new(self, x,y,range, direction)
        elsif num < 0.90
           platforms.push Platform.new(self,x,y)
        end
      end
    end
    platforms.push Platform.new(self,1550,140)
    return platforms
  end
  def update
    @camera.center_on(@player, 400, 200)
    if @game_over == false
      @seconds = (Gosu.milliseconds / 1000).to_i
      10.times do 
        @space.step(1.0/600)
      end
      if rand < BOULDER_FREQUENCY  
        @boulders.push Boulder.new(self, 200 + rand(1200), -20)
      end
      if @player.x > 1620
        @game_over = true
        @win_time = Gosu.milliseconds
      end
      @player.check_footing(@platforms + @boulders)
      if button_down?(Gosu::KbRight)
    	  @player.move_right
      elsif button_down?(Gosu::KbLeft)
        @player.move_left
      else
        @player.stand
      end
      @platforms.each do |platform|
        platform.move if platform.respond_to?(:move)
      end
      if rand < 0.001
        quake
      end
      @quake_time -= 1
      if @quake_time > 0
        @camera.shake
        if rand < 0.2
          @boulders.push Boulder.new(self, 200 + rand(1200), -20)
        end
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
  def quake
    @quake_time = 30
    @quake_sound.play
    @boulders.each do |boulder|
      boulder.quake
    end
  end
end

window = Escape.new
window.show
