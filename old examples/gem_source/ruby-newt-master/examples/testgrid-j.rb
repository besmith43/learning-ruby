#!/usr/bin/env ruby

require 'rubygems'
require "newt"

menuContents = ["°ì", "Æó", "»°", "»Í", "¸Þ"]
autoEntries = ["¥¨¥ó¥È¥ê", "ÊÌ¤Î¥¨¥ó¥È¥ê", 
  "»°ÈÖÌÜ¤Î¥¨¥ó¥È¥ê", "»ÍÈÖÌÜ¤Î¥¨¥ó¥È¥ê",]

begin
  Newt::Screen.new

  b1 = Newt::Checkbox.new(-1, -1, "¥Æ¥¹¥È¤Î¤¿¤á¤Î¤«¤Ê¤êÄ¹¤¤¥Á¥§¥Ã¥¯¥Ü¥Ã¥¯¥¹", ' ', nil)
  b2 = Newt::Button.new(-1, -1, "ÊÌ¤Î¥Ü¥¿¥ó")
  b3 = Newt::Button.new(-1, -1, "¤·¤«¤·¡¢¤·¤«¤·")
  b4 = Newt::Button.new(-1, -1, "¤·¤«¤·²¿¤À¤í¤¦¡©")

  f = Newt::Form.new

  grid = Newt::Grid.new(2, 2)
  grid.set_field(0, 0, Newt::GRID_COMPONENT, b1, 0, 0, 0, 0,
				Newt::ANCHOR_RIGHT, 0)
  grid.set_field(0, 1, Newt::GRID_COMPONENT, b2, 0, 0, 0, 0, 0, 0)
  grid.set_field(1, 0, Newt::GRID_COMPONENT, b3, 0, 0, 0, 0, 0, 0)
  grid.set_field(1, 1, Newt::GRID_COMPONENT, b4, 0, 0, 0, 0, 0, 0)

  f.add(b1, b2, b3, b4)

  grid.wrapped_window("°ìÈÖÌÜ¤Î¥¦¥£¥ó¥É¥¦")

  answer = f.run()

  #f.destroy()
  Newt::Screen.pop_window()

  flowedText, textWidth, textHeight = Newt.reflow_text("¤³¤ì¤Ï¤«¤Ê¤ê¥Æ¥­¥¹¥È¤é¤·¤¤¤â¤Î¤Ç¤¹¡£40¥«¥é¥à" +
													 "¤ÎÄ¹¤µ¤Ç¡¢¥é¥Ã¥Ô¥ó¥°¤¬¹Ô¤ï¤ì¤Þ¤¹¡£" +
													 "ÁÇÁá¤¤¡¢Ãã¿§¤Î¸Ñ¤¬¤Î¤í¤Þ¤Ê¸¤¤òÈô¤Ó" +
													 "±Û¤¨¤¿¤Î¤òÃÎ¤Ã¤Æ¤ë¤«¤¤?\n\n" +
													 "Â¾¤Ë¤ªÃÎ¤é¤»¤¹¤ë¤³¤È¤È¤·¤Æ¡¢Å¬Åö¤Ë²þ¹Ô¤ò¤¹¤ë" +
													 "¤³¤È¤¬½ÅÍ×¤Ç¤¹¡£",
													 40, 5, 5)
  t = Newt::Textbox.new(-1, -1, textWidth, textHeight, Newt::FLAG_WRAP)
  t.set_text(flowedText)

  b1 = Newt::Button.new(-1, -1, "Î»²ò")
  b2 = Newt::Button.new(-1, -1, "¥­¥ã¥ó¥»¥ë")

  grid = Newt::Grid.new(1, 2)
  subgrid = Newt::Grid.new(2, 1)

  subgrid.set_field(0, 0, Newt::GRID_COMPONENT, b1, 0, 0, 0, 0, 0, 0)
  subgrid.set_field(1, 0, Newt::GRID_COMPONENT, b2, 0, 0, 0, 0, 0, 0)

  grid.set_field(0, 0, Newt::GRID_COMPONENT, t, 0, 0, 0, 1, 0, 0)
  grid.set_field(0, 1, Newt::GRID_SUBGRID, subgrid, 0, 0, 0, 0, 0,
				Newt::GRID_FLAG_GROWX)
  grid.wrapped_window("ÊÌ¤ÎÎã")

  f = Newt::Form.new
  f.add(b1, t, b2)
  #f.add(b1, b2)
  answer = f.run()

  Newt::Screen.pop_window()
  #f.destroy()

  Newt::Screen.win_message("¥·¥ó¥×¥ë", "Î»²ò", "¤³¤ì¤Ï¥·¥ó¥×¥ë¤Ê¥á¥Ã¥»¡¼¥¸¥¦¥£¥ó¥É¥¦¤Ç¤¹")
  Newt::Screen.win_choice("¥·¥ó¥×¥ë", "Î»²ò", "¥­¥ã¥ó¥»¥ë", "¤³¤ì¤Ï¥·¥ó¥×¥ë¤ÊÁªÂò¥¦¥£¥ó¥É¥¦¤Ç¤¹")

  textWidth = Newt::Screen.win_menu("¥Æ¥¹¥È¥á¥Ë¥å¡¼", "¤³¤ì¤Ï newtWinMenu() ¥³¡¼¥ë¤Î¥µ¥ó¥×¥ë" +
									"¤Ç¤¹¡£ ¥¹¥¯¥í¡¼¥ë¥Ð¡¼¤ÏÉ¬Í×¤Ë±þ¤¸¤Æ¤Ä¤¤¤¿¤ê¡¢ " +
									"¤Ä¤«¤Ê¤«¤Ã¤¿¤ê¤·¤Þ¤¹¡£", 50, 5, 5, 3,
									menuContents, "Î»²ò", "¥­¥ã¥ó¥»¥ë")

  v = Newt::Screen.win_entries("¥Æ¥­¥¹¥È newtWinEntries()", "¤³¤ì¤Ï newtWinEntries()" +
							   "¥³¡¼¥ë¤Î¥µ¥ó¥×¥ë¤Ç¤¹¡£¤¿¤¤¤Ø¤ó´ÊÃ±¤Ë¤¿¤¯¤µ¤ó¤ÎÆþÎÏ¤ò" +
							   "°·¤¦¤³¤È¤¬¤Ç¤­¤Þ¤¹¡£", 50, 5, 5, 20, autoEntries, "Î»²ò", "¥­¥ã¥ó¥»¥ë")

ensure
  Newt::Screen.finish

  printf "item = %d\n", textWidth
  p v
end
