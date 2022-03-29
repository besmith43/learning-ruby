require 'curses'

Curses.init_screen
Curses.curs_set(0)  # Invisible cursor

begin
  # Building a static window
  win1 = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1, 0, 0)
  win1.box("o", "o")
  win1.setpos(2, 2)
  win1.addstr("Hello")
  win1.refresh

  # In this window, there will be an animation
  win2 = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1,
                            Curses.lines / 2, Curses.cols / 2)
  win2.box("|", "-")
  win2.refresh
  2.upto(win2.maxx - 3) do |i|
    win2.setpos(win2.maxy / 2, i)
    win2 << "*"
    win2.refresh
    sleep 0.05
  end

  # Clearing windows each in turn
  sleep 0.5
  win1.clear
  win1.refresh
  win1.close
  sleep 0.5
  win2.clear
  win2.refresh
  win2.close
  sleep 0.5
rescue => ex
  Curses.close_screen
end
