#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Facilitates time calculations by providing methods to convert from larger
# time units to seconds, and to convert relative time intervals to absolute
# ones. This module duplicates some of the functionality provided by Rails'
# ActiveSupport::CoreExtensions::Numeric::Time module.

module Assistance
  module TimeCalculations
    MINUTE = 60
    HOUR = 3600
    DAY = 86400
    WEEK = DAY * 7

    # Converts self from minutes to seconds
    def minutes;  self * MINUTE;  end; alias_method :minute, :minutes
    # Converts self from hours to seconds
    def hours;    self * HOUR;    end; alias_method :hour, :hours
    # Converts self from days to seconds
    def days;     self * DAY;     end; alias_method :day, :days
    # Converts self from weeks to seconds
    def weeks;    self * WEEK;    end; alias_method :week, :weeks

    # Returns the time at now - self.
    def ago(t = Time.now); t - self; end
    alias_method :before, :ago

    # Returns the time at now + self.
    def from_now(t = Time.now); t + self; end
    alias_method :since, :from_now
  end
end

# numeric extensions
class Numeric
  include Assistance::TimeCalculations
end