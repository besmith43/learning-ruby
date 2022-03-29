#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  b1 = Newt::Button.new(1, 5, "Button1")
  b2 = Newt::Button.new(1, 9, "Button2")

  b = Newt::Button.new(1, 13, "Exit")

  f = Newt::Form.new
  f.add(b1, b2, b)

  f.run()

ensure
  Newt::Screen.finish
end
