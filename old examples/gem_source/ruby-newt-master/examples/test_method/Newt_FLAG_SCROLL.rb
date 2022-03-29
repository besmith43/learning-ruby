#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin
  Newt::Screen.new

  t = Newt::Textbox.new(1, 1, 20, 10, Newt::FLAG_SCROLL)
  t.set_text("Line1\nLine2\nLine3\nLine4\nLine5\nLine6\nLine7\nLine8\nLine9\nLine10\nLine11\nLine12\nLine13\nLine14\nLine15\nLine16\nLine17")

  b = Newt::Button.new(1, 15, "Exit")

  f = Newt::Form.new
  f.add(t, b)

  f.run()

ensure
  Newt::Screen.finish
end
