#!/usr/bin/env ruby

require 'curses'

Curses.init_screen
begin
	menubar = Curses::Window.new(5, Curses.cols, 0, 0)
	menubar.box("\\", "/")
	menubar.setpos(2, Curses.cols/2)
	menubar.addstr("Menu Bar")
	menubar.refresh

	main_screen = Curses::Window.new(Curses.lines-10, Curses.cols, 6, 0)
	main_screen.box("|", "-")
	main_screen.setpos((Curses.lines-6)/2, Curses.cols/2)
	main_screen.addstr("This is the main window")
	main_screen.refresh

	sleep(10)
	main_screen.getch
ensure
	menubar.close
	main_screen.close
	Curses.close_screen
end
