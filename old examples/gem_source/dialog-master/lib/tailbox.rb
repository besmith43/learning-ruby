require_relative 'base'
require_relative 'textbox'

module Dialog

  # Displays a tailbox.
  #
  # Example:
  #
  #   Tailbox.new do |b|
  #     b.text "Bla bla"
  #   end
  #
  # Box option syntax:
  #  --tailbox <file> <height> <width>
  #
  class Tailbox < Textbox
  end

end
