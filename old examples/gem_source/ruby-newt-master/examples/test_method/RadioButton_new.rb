#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  rb1 = Newt::RadioButton.new(1, 10, "Button1", 0, nil)
  rb2 = Newt::RadioButton.new(1, 11, "Button2", 0, rb1)

  b = Newt::Button.new(1, 12, "Exit")

  f = Newt::Form.new
  f.add(rb1, rb2, b)

  f.run()

ensure
  Newt::Screen.finish
end
