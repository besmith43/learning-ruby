require_relative 'base'

module Dialog

  # Displays a textbox.
  #
  # Example:
  #
  #   Textbox.new do |b|
  #     b.text "Please read carefully"
  #     b.file "license.txt"
  #   end
  #
  # Box option syntax:
  #  --textbox <file> <height> <width>
  #
  class Textbox < Base

    # Sets the default file to display
    def file(f)
      @options.box_options[0] = case f
        when File then f.path
	else f.to_s
      end
    end

  end

end
