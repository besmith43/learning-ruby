#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
##
# Unique creates unique variable names.

class Unique
  def self.reset # mostly for testing
    @@curr = 0
  end

  def self.next
    @@curr += 1
    "temp_#{@@curr}".intern
  end

  reset
end
