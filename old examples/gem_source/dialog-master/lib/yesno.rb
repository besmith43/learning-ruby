require_relative 'base'

module Dialog

  # Displays a yes/no dialog.
  #
  # Example:
  #
  #   steps = Yesno.new do |b|
  #     b.text "Bla bla"
  #   end
  #
  # Box option syntax:
  #   --yesno <text> <height> <width>
  #
  class Yesno < Base
  end

end
