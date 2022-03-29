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
  
  ib_outlet :log, :logWindow
  ib_action :chooseApp   


  def awakeFromNib
    record('')
  end
  

  def chooseApp(sender)
    entered = sender.stringValue
    record(entered)
    @logWindow.title = entered   # (1)
  end


  def record(string)
    everything = NSRange.new(0, @log.textStorage.length)
    @log.replaceCharactersInRange_withString(everything, string)
  end
  
end
