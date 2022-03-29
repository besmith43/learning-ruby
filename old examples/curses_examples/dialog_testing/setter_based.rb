#!/usr/bin/env ruby

require 'dialog'

c = Checklist.new do
	c.backtitle "Indiana Jones and the Temple of Doom"
	c.defaultno
	c.width 60
	c.height 10
	c.title "Dinner menu"
	c.text "Dinner is ready, please choose your meal"
	c.choice "Critters", "Crispy Critters", :on
	c.choice "Snake", "Snake Surprise", :on
	c.choice "Monkey", "Iced Monkey Brain", :off
	c.ok "Serve it!"
	c.cancel "I'm not hungry"
	c.extra "Soup?"
	c.show!
end

