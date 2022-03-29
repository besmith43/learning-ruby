require_relative 'base'

module Dialog

  # Displays a msgbox.
  #
  # Example:
  #
  #   steps = Msgbox.new do |b|
  #     b.text "Bla bla"
  #   end
  #
  # Box option syntax:
  #   --msgbox <text> <height> <width>
  #
  class Msgbox < Base
  end

end
