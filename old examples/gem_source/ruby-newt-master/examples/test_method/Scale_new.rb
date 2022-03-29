#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  s = Newt::Scale.new(1, 1, 30, 100)
  s.set(20)

  b = Newt::Button.new(10, 13, "Exit")

  f = Newt::Form.new
  f.add(s, b)

  f.run()

ensure
  Newt::Screen.finish
end
