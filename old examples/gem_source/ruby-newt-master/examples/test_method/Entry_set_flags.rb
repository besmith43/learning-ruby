#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new
  #Newt::Screen.init
  #Newt::Screen.cls

  e = Newt::Entry.new(1, 1, "Entry", 10, 0)
  e.set_flags(Newt::FLAG_DISABLED, Newt::FLAGS_SET)
  e.set_flags(Newt::FLAG_DISABLED, Newt::FLAGS_RESET)

  #e.set_flags(Newt::FLAG_SCROLL, Newt::FLAGS_SET)
  e.set_flags(Newt::FLAG_SCROLL)
  #e.set_flags(Newt::FLAG_SCROLL | Newt::FLAG_DISABLED)
  #e.set_flags(Newt::FLAG_HIDDEN, Newt::FLAGS_SET)

  b = Newt::Button.new(10, 13, "Exit")

  f = Newt::Form.new
  f.add(e, b)

  f.run()

  v = e.get
ensure
  Newt::Screen.finish
end
