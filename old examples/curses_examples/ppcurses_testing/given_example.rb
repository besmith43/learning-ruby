require 'ppcurses'

def displayMenu
  mainMenu = PPCurses::Menu.new( [ "Press", "<ESCAPE>", "to Quit" ])
  mainMenu.show
  mainMenu.menu_selection
  mainMenu.close
end

screen = PPCurses::Screen.new
screen.run { displayMenu }
