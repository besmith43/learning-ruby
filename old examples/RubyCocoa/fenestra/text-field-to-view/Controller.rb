#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'osx/cocoa'

class Controller < OSX::NSObject
  include OSX

  attr_writer :log              # (1)

  def awakeFromNib              # (2)
    record('')
  end
  
  def chooseApp(sender)      # (3)
    record(sender.stringValue)
  end

  def record(string)
    everything = NSRange.new(0, @log.textStorage.length)  # (4)
    @log.replaceCharactersInRange_withString(everything, string) # (5)
  end
end
