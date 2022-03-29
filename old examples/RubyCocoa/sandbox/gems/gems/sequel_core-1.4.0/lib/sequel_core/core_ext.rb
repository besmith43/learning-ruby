#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# Enumerable extensions.
module Enumerable
  # Invokes the specified method for each item, along with the supplied
  # arguments.
  def send_each(sym, *args)
    each {|i| i.send(sym, *args)}
  end
end

# Range extensions
class Range
  # Returns the interval between the beginning and end of the range.
  def interval
    last - first
  end
end

# Object extensions
class Object
  def is_one_of?(*classes)
    classes.each {|c| return c if is_a?(c)}
    nil
  end
end

