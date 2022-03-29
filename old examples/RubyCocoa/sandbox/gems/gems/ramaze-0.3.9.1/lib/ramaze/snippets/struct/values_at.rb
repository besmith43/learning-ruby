#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

# Extensions for Struct

class Struct

  # Example:
  #  Point = Struct.new(:x, :y)
  #  point = Point.new(15, 10)
  #  point.values_at(:y, :x)
  #  # => [10, 15]
  #  point.values_at(0, 1)
  #  # => [15, 10]

  def values_at(*keys)
    if keys.all?{|key| key.respond_to?(:to_int) and not key.is_a?(Symbol) }
      keys.map{|key| values[key.to_int] }
    else
      keys.map{|k| self[k] }
    end
  end
end
