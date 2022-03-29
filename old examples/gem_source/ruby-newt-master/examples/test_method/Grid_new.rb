#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  b1 = Newt::Button.new(-1, -1, "Button1")
  b2 = Newt::Button.new(-1, -1, "Button2")

  b = Newt::Button.new(-1, -1, "Exit")

  grid = Newt::Grid.new(2, 0)
  grid.setField(0, 0, Newt::GRID_COMPONENT, b1, 0, 0, 0, 0, 0, 0)
  grid.setField(0, 1, Newt::GRID_COMPONENT, b2, 0, 0, 0, 0, 0, 0)
  grid.setField(1, 0, Newt::GRID_COMPONENT, b, 0, 0, 0, 0, 0, 0)
  
  f = Newt::Form.new
  f.add(b1, b2, b)
  f.run()

ensure
  Newt::Screen.finish
end
