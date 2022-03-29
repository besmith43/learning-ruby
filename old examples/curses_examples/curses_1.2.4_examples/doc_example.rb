require "curses"

Curses.init_screen

my_str = "LOOK! PONIES!"

height, width = 12, my_str.length + 10
top, left = (Curses.lines - height) / 2, (Curses.cols - width) / 2
bwin = Curses::Window.new(height, width, top, left)
bwin.box("\\", "/")
bwin.refresh

win = bwin.subwin(height - 4, width - 4, top + 2, left + 2)
win.setpos(2, 3)
win.addstr(my_str)
# or even
win << "\nOH REALLY?"
win << "\nYES!! " + my_str
win.refresh
win.getch
win.close
