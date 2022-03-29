require_relative 'base'
require_relative 'textbox'

module Dialog

  # Displays a tailbox in the background.
  #
  # Example:
  #
  #   Tailboxbg.new do |b|
  #     b.text "Bla bla"
  #     b.file "/var/log/messages"
  #   end
  #
  # Box option syntax:
  #  --tailboxbg <file> <height> <width>
  #
  class Tailboxbg < Textbox
  end

end
