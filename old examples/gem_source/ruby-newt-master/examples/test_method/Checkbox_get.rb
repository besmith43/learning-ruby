#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  cb1 = Newt::Checkbox.new(1, 10, "Button1", '', nil)
  cb2 = Newt::Checkbox.new(1, 11, "Button2", '', nil)

  b = Newt::Button.new(1, 12, "Exit")

  f = Newt::Form.new
  f.add(cb1, cb2, b)

  f.run()

  v1, v2 = cb1.get, cb2.get
ensure
  Newt::Screen.finish
end

p v1, v2
