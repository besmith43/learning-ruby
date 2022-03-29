require_relative 'base'

module Dialog

  # Displays a passwordbox.
  #
  # Example:
  #
  #   Passwordbox.new do |b|
  #     b.text "Speak friend and enter"
  #     b.value "Mellon"
  #   end
  #
  # Box option syntax:
  #  --passwordbox  <text> <height> <width> [<init>]
  #
  class Passwordbox < Inputbox
  end

end
