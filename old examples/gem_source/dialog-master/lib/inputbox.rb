require_relative 'base'

module Dialog

  # Displays an inputbox.
  #
  # Example:
  #
  #   steps = Dialog::inputbox do |b|
  #     b.text "Bla bla"
  #     b.value "Initial input"
  #   end
  #
  # Box option syntax:
  #  --inputbox <text> <height> <width> [<init>]
  #
  class Inputbox < Base

    # Sets the intial value for the input box
    def value(s)
      @options.box_options[3] = s
    end

  end

end
