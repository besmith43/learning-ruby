#!/usr/bin/env ruby

require 'rubygems'
require "newt"

menuContents = ["One", "Two", "Three", "Four", "Five"]
autoEntries = ["An entry", "Another entry",
  "Third entry", "Fourth entry"]

Newt::Screen.new

b1 = Newt::Checkbox.new(-1, -1, "An pretty long checkbox for testing", ' ', nil)
b2 = Newt::Button.new(-1, -1, "Another Button")
b3 = Newt::Button.new(-1, -1, "But, but")
b4 = Newt::Button.new(-1, -1, "But what?")

f = Newt::Form.new

grid = Newt::Grid.new(2, 2)
grid.set_field(0, 0, Newt::GRID_COMPONENT, b1, 0, 0, 0, 0,
			   Newt::ANCHOR_RIGHT, 0)
grid.set_field(0, 1, Newt::GRID_COMPONENT, b2, 0, 0, 0, 0, 0, 0)
grid.set_field(1, 0, Newt::GRID_COMPONENT, b3, 0, 0, 0, 0, 0, 0)
grid.set_field(1, 1, Newt::GRID_COMPONENT, b4, 0, 0, 0, 0, 0, 0)

f.add(b1, b2, b3, b4)

grid.wrapped_window("first window")

answer = f.run()

#f.destroy()
Newt::Screen.pop_window()

flowedText, textWidth, textHeight = Newt.reflow_text("This is a quite a bit of text. It is 40 " +
													 "columns long, so some wrapping should be " +
													 "done. Did you know that the quick, brown " +
													 "fox jumped over the lazy dog?\n\n" +
													 "In other news, it's pretty important that we " +
													 "can properly force a line break.",
													 40, 5, 5)
t = Newt::Textbox.new(-1, -1, textWidth, textHeight, Newt::FLAG_WRAP)
t.set_text(flowedText)


b1 = Newt::Button.new(-1, -1, "Okay")
b2 = Newt::Button.new(-1, -1, "Cancel")

grid = Newt::Grid.new(1, 2)
subgrid = Newt::Grid.new(2, 1)

subgrid.set_field(0, 0, Newt::GRID_COMPONENT, b1, 0, 0, 0, 0, 0, 0)
subgrid.set_field(1, 0, Newt::GRID_COMPONENT, b2, 0, 0, 0, 0, 0, 0)

grid.set_field(0, 0, Newt::GRID_COMPONENT, t, 0, 0, 0, 1, 0, 0)
grid.set_field(0, 1, Newt::GRID_SUBGRID, subgrid, 0, 0, 0, 0, 0,
			  Newt::GRID_FLAG_GROWX)
grid.wrapped_window("another example")

f = Newt::Form.new
f.add(b1, t, b2)
#f.add(b1, b2)
answer = f.run()

Newt::Screen.pop_window()
#f.destroy()

Newt::Screen.win_message("Simple", "Ok", "This is a simple message window")
Newt::Screen.win_choice("Simple", "Ok", "Cancel", "This is a simple choice window")

textWidth = Newt::Screen.win_menu("Test Menu", "This is a sample invovation of the " +
						"newtWinMenu() call. It may or may not have a scrollbar, " +
						"depending on the need for one.", 50, 5, 5, 3,
						menuContents, "Ok", "Cancel")

v = Newt::Screen.win_entries("Text newtWinEntries()", "This is a sample invovation of " +
						 "newtWinEntries() call. It lets you get a lot of input " +
						 "quite easily.", 50, 5, 5, 20, autoEntries, "Ok", "Cancel")

Newt::Screen.finish

printf "item = %d\n", textWidth
p v
