#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin

  Newt::Screen.new

  v = Newt::Screen.win_menu("Test Menu", "Text", 50, 5, 5, 3,
							["One", "Two", "Three"], "OK")

  #Newt::Screen.wait_for_key

ensure
  Newt::Screen.finish
end

p v
