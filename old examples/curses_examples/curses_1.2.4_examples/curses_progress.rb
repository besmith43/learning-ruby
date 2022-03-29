require 'curses'
require 'ruby-progressbar'

def main_screen
	height = Curses.lines
	width = Curses.cols
	top = 0
	left = 0
	win = Curses::Window.new(height, width, top, left)
	win.box("|", "-")
	win.setpos((Curses.lines-top)/2, (Curses.cols/2))
	prog_bar = ProgressBar.create(:length => 40)
	prog_bar.total=(10)
	until prog_bar.finished?
		prog_bar.increment
		sleep(1)
		win.refresh
	end
	return win
end

Curses.init_screen
begin
	main_w = main_screen
	until ((ch=main_w.getch) == 'q')
		sleep(0.01)
	end
ensure
	Curses.close_screen
end
