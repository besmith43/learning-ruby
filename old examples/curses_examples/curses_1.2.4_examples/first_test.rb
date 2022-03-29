#!/usr/bin/env ruby

require 'curses'

def display_instruction
	message = "Enter a message: "
	height = 5
	width = message.length + 20
	top = (Curses.lines - height)/2
	left = (Curses.cols - width)/2
	win = Curses::Window.new(height, width, top, left)
	win.box("\\", "/")
	win.setpos(2,3)
	win.addstr(message)
	win.refresh
	user_string = win.getstr
	win.close
	return user_string
end

def show_message(message)
	height = 5
	width = message.length + 6
	top = (Curses.lines - height)/2
	left = (Curses.cols - width)/2
	win = Curses::Window.new(height, width, top, left)
	win.box("|", "-")
	win.setpos(2,3)
	win.addstr(message)
	win.refresh
	win.getch
	win.close
end

Curses.init_screen
begin
	Curses.setpos((Curses.lines-1)/2, (Curses.cols-11)/2)
	user_string = display_instruction
	Curses.clear
	Curses.refresh
	show_message(user_string)
ensure
	Curses.close_screen
end
