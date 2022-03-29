#---
# Excerpted from "Learn Game Programming with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/msgpkids for more book information.
#---
#SectorFive_2
require 'gosu'
require_relative 'player'
require_relative 'enemy'
class SectorFive < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  def initialize
    super(WIDTH,HEIGHT)
    self.caption = 'Sector Five'
    @player = Player.new(self)
    @enemy = Enemy.new(self)
  end
  def update
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
    @enemy.move
  end
  def draw
    @player.draw
    @enemy.draw
  end
end

window = SectorFive.new
window.show
