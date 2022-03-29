#!/usr/bin/env ruby

require 'rubygems'
require "newt"

begin
  Newt::Screen.new

  Newt::Screen.init

  Newt::Screen.draw_roottext(1, 1, "Test")
  Newt::Screen.wait_for_key

ensure
  Newt::Screen.finish
end
