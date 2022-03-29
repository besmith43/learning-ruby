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
  
  ib_outlets :log, :logWindow, :choice
  ib_action :chooseApp   


  def awakeFromNib
    @log.clear  # (1)
    @choice.stringValue = "com.exampler.counting"   # (2)
  end

  
  def chooseApp(sender)
    app_name = sender.stringValue
    center = NSDistributedNotificationCenter.defaultCenter
    center.addObserver_selector_name_object(self, :displayNotification,
                                             nil, app_name) 

    @log.addLine "Observing #{app_name}..."
    @logWindow.title = app_name
  end

  def displayNotification(notification)
    @log.addLine(notification.to_s)
  end


  def windowWillClose(notification)
    NSApp.terminate(self)
  end

end
