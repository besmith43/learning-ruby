require 'ppcurses'

def displayMenu
	mainMenu = PPCurses::Menu.new( [ "Press", "<ESCAPE>", "to Quit" ])
	#mainMenu.set_origin 20
	mainMenu.show
	mainMenu.menu_selection
	mainMenu.close
end

screen = PPCurses::Screen.new
screen.run {displayMenu }
