#!/usr/bin/env ruby

require 'rubygems'
require "newt"

Newt::Screen.new

checktree = Newt::CheckboxTreeMulti.new(-1, -1, 10, " ab", Newt::FLAG_SCROLL)
checktree.add("¥Ê¥ó¥Ð¡¼", 2, 0, Newt::ARG_APPEND)
checktree.add("ËÜÅö¤ËËÜÅö¤ËÄ¹¤¤¥â¥Î", 3, 0, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£µ", 5, Newt::FLAG_SELECTED, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£¶", 6, 0, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£·", 7, Newt::FLAG_SELECTED, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£¸", 8, 0, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£¹", 9, 0, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£±£°", 10, Newt::FLAG_SELECTED, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£±£±", 11, 0, Newt::ARG_APPEND)
checktree.add("¥Ê¥ó¥Ð¡¼£±£²", 12, Newt::FLAG_SELECTED, Newt::ARG_APPEND)

checktree.add("¥«¥é¡¼", 1, 0, 0)
checktree.add("ÀÖ¿§", 100, 0, 0, Newt::ARG_APPEND)
checktree.add("Çò¿§", 101, 0, 0, Newt::ARG_APPEND)
checktree.add("ÀÄ¿§", 102, 0, 0, Newt::ARG_APPEND)

checktree.add("¥Ê¥ó¥Ð¡¼£´", 4, 0, 3)

checktree.add("°ì·å¤Î¿ô»ú", 200, 0, 1, Newt::ARG_APPEND)
checktree.add("°ì", 201, 0, 1, 0, Newt::ARG_APPEND)
checktree.add("Æó", 202, 0, 1, 0, Newt::ARG_APPEND)
checktree.add("»°", 203, 0, 1, 0, Newt::ARG_APPEND)
checktree.add("»Í", 204, 0, 1, 0, Newt::ARG_APPEND)

checktree.add("Æó·å¤Î¿ô»ú", 300, 0, 1, Newt::ARG_APPEND)
checktree.add("½½", 210, 0, 1, 1, Newt::ARG_APPEND)
checktree.add("½½°ì", 211, 0, 1, 1, Newt::ARG_APPEND)
checktree.add("½½Æó", 212, 0, 1, 1, Newt::ARG_APPEND)
checktree.add("½½»°", 213, 0, 1, 1, Newt::ARG_APPEND)

button = Newt::Button.new(-1, -1, "½ªÎ»")

grid = Newt::Grid.new(1, 2)
grid.set_field(0, 0, Newt::GRID_COMPONENT, checktree, 0, 0, 0, 1,
			  Newt::ANCHOR_RIGHT, 0)
grid.set_field(0, 1, Newt::GRID_COMPONENT, button, 0, 0, 0, 0,
			  0, 0)

grid.wrapped_window("¥Á¥§¥Ã¥¯¥Ü¥Ã¥¯¥¹¥Ä¥ê¡¼¥Æ¥¹¥È")

form = Newt::Form.new
form.add(checktree, button)

answer = form.run()

Newt::Screen.finish

