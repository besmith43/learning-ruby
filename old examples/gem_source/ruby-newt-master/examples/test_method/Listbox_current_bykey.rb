#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  l1 = Newt::Listbox.new(1, 1, 10, Newt::FLAG_SCROLL)
  1.upto(10) do |i|
	l1.append("item #{i}", i)
  end
  l1.append("ITEM", 11)
  1.upto(10) do |i|
	l1.append("item #{i+11}", i+11)
  end
  l1.setCurrentByKey("ITEM")

  b = Newt::Button.new(1, 12, "Exit")

  f = Newt::Form.new
  f.add(l1, b)

  f.run()

ensure
  Newt::Screen.finish
end
