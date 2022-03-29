#!/usr/bin/env ruby

require 'curses'

def menubar
	height = 5
	width = Curses.cols
	top = 0
	left = 0
	win = Curses::Window.new(height, width, top, left)
	win.box("\\", "/")
	win.setpos(2,(Curses.cols/2))
	win.addstr("Menu Bar")
	win.refresh
end

def main_screen
	height = Curses.lines-5
	width = Curses.cols
	top = 6
	left = 0
	win = Curses::Window.new(height, width, top, left)
	win.box("|", "-")
	win.setpos((Curses.lines-top)/2, (Curses.cols/2))
	win.addstr("This is the main window")
	win.refresh
end

Curses.init_screen
begin
	menubar
	main_screen
	sleep(10)
	Curses.getch
ensure
	Curses.close_screen
end
