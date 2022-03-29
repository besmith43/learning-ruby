require_relative 'base'

module Dialog

  # Displays a file selection box.
  #
  # Corresponds to the --fselect box option. Use the file method
  # to set the file to be displayed.
  #
  # Example:
  #
  #   steps = Dialog::fselect do |m|
  #     m.text "Select a device!"
  #     m.file "/dev/null"
  #   end
  #
  # Box option syntax:
  #   --fselect <filepath> <height> <width>
  #
  class FSelect < Base

    # Sets the default file to display
    def file(f)
      @options.box_options[0] = case f
        when File then f.path
	  else f.to_s
      end
    end

  end

end
