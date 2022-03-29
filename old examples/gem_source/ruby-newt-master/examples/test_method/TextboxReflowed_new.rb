#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  text = "Line1 Line1 Line1 Line1 Line1 Line1 Line1 Line1 \nLine2"
  t = Newt::TextboxReflowed.new(1, 1, text, 20, 0, 0, 0)

  b = Newt::Button.new(1, 15, "Exit")

  f = Newt::Form.new
  f.add(t, b)

  f.run()

ensure
  Newt::Screen.finish
end

