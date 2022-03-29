require_relative 'base'

module Dialog

  # Displays an infobox.
  #
  # Corresponds to the --infobox box option.
  #
  # Example:
  #
  #   steps = Dialog::infobox do |b|
  #     b.text "Bla bla"
  #   end
  #
  # Box option syntax:
  #   --infobox <text> <height> <width>
  #
  class Infobox < Base
  end

end
