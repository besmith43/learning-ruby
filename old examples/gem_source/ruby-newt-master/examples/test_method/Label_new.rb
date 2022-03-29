#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  l1 = Newt::Label.new(1, 5, "Label1")
  l2 = Newt::Label.new(1, 9, "Label2")

  b = Newt::Button.new(1, 13, "Exit")

  f = Newt::Form.new
  f.add(l1, l2, b)

  f.run()

ensure
  Newt::Screen.finish
end
