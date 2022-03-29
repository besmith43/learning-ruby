#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  cb1 = Newt::Checkbox.new(1, 10, "Button1", 'A', nil)
  cb2 = Newt::Checkbox.new(1, 11, "Button2", '', '+')

  b = Newt::Button.new(1, 12, "Exit")

  f = Newt::Form.new
  f.add(cb1, cb2, b)

  f.run()

ensure
  Newt::Screen.finish
end
