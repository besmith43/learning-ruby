require 'curses'

def main_screen(content)
	height = Curses.lines
	width = Curses.cols
	top = 0
	left = 0
	win = Curses::Window.new(height, width, top, left)
	win.box("|", "-")
	win.setpos((Curses.lines-top)/2, (Curses.cols/2))
	x = win.curx
	y = win.cury
	win.addstr("#{content[0]}")
	win.setpos(y-1, x)
	win.addstr("#{content[1]}")
	win.setpos(y-2, x)
	win.addstr("#{content[2]}")
	win.setpos(y-3, x)
	win.addstr("#{content[3]}")
	win.setpos(y-4, x)
	win.addstr("#{content[4]}")
	win.refresh
	return win
end

Curses.init_screen
begin
	stuff = Array.new(5) { Array.new(5, 0) }
	main_w = main_screen(stuff)
	until ((ch=main_w.getch) == 'q')
		sleep(0.5)
	end
ensure
	Curses.close_screen
end
