#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  l1 = Newt::Listbox.new(1, 1, 10, Newt::FLAG_SCROLL)
  l1.insert("item 1", 1, 0)
  l1.insert("item 3", 2, 1)
  l1.insert("item 2", 3, 1)

  b = Newt::Button.new(1, 12, "Exit")

  f = Newt::Form.new
  f.add(l1, b)

  f.run()

ensure
  Newt::Screen.finish
end
