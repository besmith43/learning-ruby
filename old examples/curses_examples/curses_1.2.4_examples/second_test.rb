#!/usr/bin/env ruby

require 'curses'

Curses.init_screen
begin
	win = Curses::Window.new(5, 20, 10, 10)
	win.box("\\", "/")
	win.setpos(2,5)
	win.addstr("testing")
	win.refresh
	win.getch
	win.close
ensure
	Curses.close_screen
end

