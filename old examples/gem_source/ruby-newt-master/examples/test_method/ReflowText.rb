#!/usr/bin/env ruby

require 'rubygems'
require "newt"

text = ""
width = 0
height = 0

begin

  Newt::Screen.new

  text, width, height = Newt.reflow_text("This is a quite a bit of text. It is 40 " +
										 "columns long, so some wrapping should be " +
										 "done. Did you know that the quick, brown " +
										 "fox jumped over the lazy dog?\n\n" +
										 "In other news, it's pretty important that we " +
										 "can properly force a line break.", 40, 5, 5)

ensure
  Newt::Screen.finish
end

p text
p width
p height
