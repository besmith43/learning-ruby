#!/usr/bin/env ruby

require 'rubygems'
require "newt"

Newt::Screen.new

checktree = Newt::CheckboxTreeMulti.new(-1, -1, 10, " ab", Newt::FLAG_SCROLL)
checktree.add("Numbers", 2, 0, Newt::ARG_APPEND)
checktree.add("Really really long thing", 3, 0, Newt::ARG_APPEND)
checktree.add("number 5", 5, Newt::FLAG_SELECTED, Newt::ARG_APPEND)
checktree.add("number 6", 6, 0, Newt::ARG_APPEND)
checktree.add("number 7", 7, Newt::FLAG_SELECTED, Newt::ARG_APPEND)
checktree.add("number 8", 8, 0, Newt::ARG_APPEND)
checktree.add("number 9", 9, 0, Newt::ARG_APPEND)
checktree.add("number 10", 10, Newt::FLAG_SELECTED, Newt::ARG_APPEND)
checktree.add("number 11", 11, 0, Newt::ARG_APPEND)
checktree.add("number 12", 12, Newt::FLAG_SELECTED, Newt::ARG_APPEND)

checktree.add("Colors", 1, 0, 0)
checktree.add("Red", 100, 0, 0, Newt::ARG_APPEND)
checktree.add("White", 101, 0, 0, Newt::ARG_APPEND)
checktree.add("Blue", 102, 0, 0, Newt::ARG_APPEND)

checktree.add("number 4", 4, 0, 3)

checktree.add("Single digit", 200, 0, 1, Newt::ARG_APPEND)
checktree.add("One", 201, 0, 1, 0, Newt::ARG_APPEND)
checktree.add("Two", 202, 0, 1, 0, Newt::ARG_APPEND)
checktree.add("Three", 203, 0, 1, 0, Newt::ARG_APPEND)
checktree.add("Four", 204, 0, 1, 0, Newt::ARG_APPEND)

checktree.add("Double digit", 300, 0, 1, Newt::ARG_APPEND)
checktree.add("Ten", 210, 0, 1, 1, Newt::ARG_APPEND)
checktree.add("Eleven", 211, 0, 1, 1, Newt::ARG_APPEND)
checktree.add("Twelve", 212, 0, 1, 1, Newt::ARG_APPEND)
checktree.add("Thirteen", 213, 0, 1, 1, Newt::ARG_APPEND)

button = Newt::Button.new(-1, -1, "Exit")

grid = Newt::Grid.new(1, 2)
grid.set_field(0, 0, Newt::GRID_COMPONENT, checktree, 0, 0, 0, 1,
			  Newt::ANCHOR_RIGHT, 0)
grid.set_field(0, 1, Newt::GRID_COMPONENT, button, 0, 0, 0, 0,
			  0, 0)

grid.wrapped_window("Checkbox Tree Test")

form = Newt::Form.new
form.add(checktree, button)

answer = form.run()

Newt::Screen.finish
