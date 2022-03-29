require_relative 'base'

module Dialog

  # Displays a time input box.
  #
  # Use the time method to set the time being displayed initially.
  #
  # Example:
  #
  #   Timebox.new do |t|
  #     t.text "What time is it?"
  #     m.time Time.now
  #   end
  #
  # Box option syntax:
  #   --timebox <text> <height> <width> <hour> <minute> <second>
  class Timebox < Base

    # Sets the default time to display initially
    def time(t)
      if !t.kind_of?(Time)
        t = Time.parse(d)
      end
      @options.box_options[3..5] = [t.hour, t.min, t.sec]
    end

  end

end
