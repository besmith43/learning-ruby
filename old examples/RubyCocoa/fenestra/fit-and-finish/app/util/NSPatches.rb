#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'


module OSX
  class NSTextView
    def clear
      # ...

      everything = NSRange.new(0, textStorage.length)
      replaceCharactersInRange_withString(everything, '')

    end

  
    def addLine(string)
      string += "\n"
      at_end = NSRange.new(textStorage.length, 0)
      replaceCharactersInRange_withString(at_end, string)
    end

  end


  class NSCFBoolean
    def negate
      if false.to_ns == self
        true.to_ns
      else
        false.to_ns
      end
    end
  end

end

