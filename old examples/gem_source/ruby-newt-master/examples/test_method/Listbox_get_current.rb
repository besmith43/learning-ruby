#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  l1 = Newt::Listbox.new(1, 1, 10, Newt::FLAG_SCROLL)
  1.upto(20) do |i|
	l1.append("item #{i}", i)
  end

  b = Newt::Button.new(1, 12, "Exit")

  f = Newt::Form.new
  f.add(l1, b)

  f.run()

  v = l1.get_current

ensure
  Newt::Screen.finish
end

p v
