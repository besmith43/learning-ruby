require_relative 'base'

module Dialog

  # Displays a gauge.
  #
  # Corresponds to the --gauge box option. Use the complete method
  # to set the initially completed part of the gauge. TODO How do
  # we update the gauge??
  #
  # Example:
  #
  #   steps = Dialog::gauge do |m|
  #     m.text "Please wait"
  #     m.complete 30  # 30% complete, 0.3 works as well
  #   end
  #
  # Box option syntax:
  #   --gauge <text> <height> <width> [<percent>]
  #
  class Gauge < Base

    # Sets the value to display
    def complete(p)
      @completed = case p
        when Fixnum then p
        when Bignum then p
        when Float then (p*100).to_i
        else p
      end
      @stdin.puts @completed if @stdin
    end

    def arguments
      super << @completed || 0
    end

    # Make sure wait returns by closing stdin
    def wait
      @stdin.close if @stdin
      super
    end

  end

end
