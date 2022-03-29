require_relative 'base'

module Dialog

  # Displays a calendar.
  #
  # Corresponds to the --calendar box option. Use the date method to
  # set the date being displayed.
  #
  # Example:
  #
  #   steps = Dialog::calendar do |m|
  #     m.text "Bla bla"
  #     m.date Date.today
  #   end
  #
  # Box option syntax:
  #   --calendar <text> <height> <width> <day> <month> <year>
  class Calendar < Base

    # Sets the default date to display
    def date(d)
      if !d.kind_of?(Date)
        d = ParseDate::parsedate(d)
      end
      @options.box_options[3..5] = [d.day, d.month, d.year]
    end

  end

end
