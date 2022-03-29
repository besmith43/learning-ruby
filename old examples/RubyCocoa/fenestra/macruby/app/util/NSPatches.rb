#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
# PORT: No more module OSX

  class NSTextView
    def clear
      everything = NSRange.new(0, textStorage.length)
      replaceCharactersInRange everything, withString: ""
    end
  
    def addLine(string)
      string += "\n"
      at_end = NSRange.new(textStorage.length, 0)
      self.replaceCharactersInRange at_end, withString: string
    end
  end

