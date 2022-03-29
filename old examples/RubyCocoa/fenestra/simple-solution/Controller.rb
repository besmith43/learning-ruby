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
  
  ib_outlets :log, :logWindow, :choice    # (1) 
  ib_action :chooseApp   

  def awakeFromNib
    clear_log  
    @choice.stringValue = "com.exampler.counting"  # (2)
  end
  
  def chooseApp(sender)
    app_name = sender.stringValue
    center = NSDistributedNotificationCenter.defaultCenter
    center.addObserver_selector_name_object(self, :displayNotification,
                                             nil, app_name) # (3)

    record("Observing #{app_name}...")  # (4) 
    @logWindow.title = app_name
  end

  def displayNotification(notification)
    record(notification.to_s)
  end

  def windowWillClose(notification)
    NSApp.terminate(self)
  end
  
  private
  
  def clear_log # (5)
    everything = NSRange.new(0, @log.textStorage.length)
    @log.replaceCharactersInRange_withString(everything, '')
  end
  
  def record(string) # (6)
    string += "\n"
    at_end = NSRange.new(@log.textStorage.length, 0)
    @log.replaceCharactersInRange_withString(at_end, string)
  end
end
