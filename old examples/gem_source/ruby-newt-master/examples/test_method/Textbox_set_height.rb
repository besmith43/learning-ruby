#!/usr/bin/env ruby

# ?

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  t = Newt::Textbox.new(1, 1, 20, 10, Newt::FLAG_WRAP)
  t.set_text("Line1\nLine2\nLine3")
  t.set_height(5)

  b = Newt::Button.new(1, 13, "Exit")

  f = Newt::Form.new
  f.add(t, b)

  f.run()

ensure
  Newt::Screen.finish
end
