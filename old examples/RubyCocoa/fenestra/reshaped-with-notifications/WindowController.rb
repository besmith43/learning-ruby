#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require 'Controller'

class WindowController < Controller
  ib_outlet :logWindow


  def awakeFromNib
    Center.addObserver_selector_name_object(self, :note_choice,
                                            AppChosen, nil)
    Center.addObserver_selector_name_object(self, :forget_app,
                                            TimeToForgetApp, nil)
  end

  def note_choice(notification)
    @logWindow.title = notification.userInfo[:app_name]
  end

  def forget_app(notification)
    @logWindow.title = "- No App -" 
  end


  def windowWillClose(notification)
    NSApp.terminate(self)
  end
end

