require 'rubygems'
require 'dialog'

include Dialog

yn = Yesno.new do |d|
	d.text "What... is your favourite colour?"
	d.yes "Blue"
	d.no "Yellow"
end
yn.show!
