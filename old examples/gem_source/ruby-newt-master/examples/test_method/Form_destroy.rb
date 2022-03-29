#!/usr/bin/env ruby

# ?

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  b1 = Newt::Button.new(1, 5, "Button1")
  b2 = Newt::Button.new(1, 9, "Button2")

  b = Newt::Button.new(1, 13, "Exit")

  f = Newt::Form.new
  f.set_height(20)
  f.add(b1, b2, b)
  #f.set_height(20)


  b1.callback ( proc { f.destroy } )
  b2.callback ( proc { Newt::Screen.bell })

begin
  answer = f.run()
end while answer != nil


ensure
  Newt::Screen.finish
end
